#!/usr/bin/env python3
import json
import sys
from collections import defaultdict
from datetime import datetime

import matplotlib.pyplot as plt
import numpy as np

TAGS = {
    "Deployment",
    "Fix",
    "HR",
    "Learning",
    "Improvements",
    "Interview",
    "Issue",
    "Maintenance",
    "Meeting",
    "Messages",
    "Organize",
    "PRreview",
    "Support",
    "Task",
    "Tooling",
}


# sys.stdin will look like


def annotate_pie(wedges, pie, labels):
    """Add labels pointing to each pie slice."""
    # https://matplotlib.org/stable/gallery/pie_and_polar_charts/pie_and_donut_labels.html
    bbox_props = {"boxstyle": "square,pad=0.3", "fc": "w", "ec": "k", "lw": 0.72}
    kw = {
        "arrowprops": {"arrowstyle": "-"},
        "bbox": bbox_props,
        "zorder": 0,
        "va": "center",
    }

    for i, p in enumerate(wedges):
        ang = (p.theta2 - p.theta1) / 2.0 + p.theta1
        y = np.sin(np.deg2rad(ang))
        x = np.cos(np.deg2rad(ang))
        horizontalalignment = {-1: "right", 1: "left"}[int(np.sign(x))]
        connectionstyle = f"angle,angleA=0,angleB={ang}"
        kw["arrowprops"].update({"connectionstyle": connectionstyle})
        pie.annotate(
            labels[i],
            xy=(x, y),
            xytext=(1.35 * np.sign(x), 1.4 * y),
            horizontalalignment=horizontalalignment,
            **kw,
        )


def read_timew_input():
    """Read timew records from stdin, provided by the `timewarrior report` command.
    The input will look like:
      color: on
      debug: off
      ...
      [
      {"id":14,"start":"20240604T110859Z","end":"20240604T112910Z","tags":["BAU","Fix"],"annotation":"Fix docker build for devpi images"},
      {"id":13,"start":"20240604T112910Z","end":"20240604T120000Z","tags":["BAU","Fix","RPGTEAM-1787","Task"],"annotation":"Rebuild all docker images - Fix failed Jobs"},
      ...
      ]
    """
    records = ""
    line = ""

    while not line.startswith("["):
        line = sys.stdin.readline().strip()

    while not line.endswith("]"):
        records += line.strip()
        line = sys.stdin.readline().strip()
    records += line.strip()

    return json.loads(records)


def parse_records(records):
    """Within each Tag category, return total time spent by annotation.
    {
        "Task": {
            "annotation1": 4392.3,
            "annotation2": 29.
        },
        "Support": {
            "annotation1": ...,
            "annotation2": ...
        }
    }
    """
    time_by_annotations_by_tag = {tag: {} for tag in TAGS}

    for record in records:
        if not set(record["tags"]) & TAGS:
            print(
                f'WARNING: @{record["id"]} is missing a top level tag. Skipped.',
                file=sys.stderr,
            )
            continue

        start = datetime.strptime(record["start"], "%Y%m%dT%H%M%SZ")
        end = datetime.strptime(record["end"], "%Y%m%dT%H%M%SZ")
        spent = (end - start).total_seconds()
        annotation = record["annotation"] if "annotation" in record else "empty"

        for tag in record["tags"]:
            if tag not in TAGS:
                continue
            if annotation in time_by_annotations_by_tag[tag]:
                time_by_annotations_by_tag[tag][annotation] += spent
            else:
                time_by_annotations_by_tag[tag][annotation] = spent

    return time_by_annotations_by_tag


def total_time_spent_by_tag(time_by_annotations_by_tag):
    """Given a time_by_annotations_by_tag dictionary,
    return a tuple with 2 elements:
        - time_spent_by_tag: total time spent by tag.
            All tags under 3% total time are grouped in a new "Others" tag.
        - time_spent_by_minor_tag: detail of total time spent by tag in "Others".
    """
    time_spent_by_tag = {
        tag: sum(time_by_annotations_by_tag[tag].values())
        for tag in time_by_annotations_by_tag
    }
    time_spent_by_minor_tag = {}
    dropped = []

    total_time_spent = sum(time_spent_by_tag.values())

    for tag in time_spent_by_tag:
        if time_spent_by_tag[tag] / total_time_spent < 0.03:
            if time_spent_by_tag[tag] / total_time_spent < 0.005:
                print(
                    f"{tag} represents less than 0.5% of total time spent. Dropped.",
                    file=sys.stderr,
                )
                dropped.append(tag)
                continue
            print(
                f"{tag} represents less than 3% of total time spent. Moved to 'Others'.",
                file=sys.stderr,
            )
            time_spent_by_minor_tag[tag] = time_spent_by_tag[tag]

    for minor_tag in time_spent_by_minor_tag:
        del time_spent_by_tag[minor_tag]
    for dropped_tag in dropped:
        del time_spent_by_tag[dropped_tag]
    time_spent_by_tag["Others"] = sum(time_spent_by_minor_tag.values())

    return time_spent_by_tag, time_spent_by_minor_tag


def print_annotations(time_by_annotations_by_tag):
    """Print annotations to stderr, grouped by tag and ordered by time spent."""
    # Sort just for stderr print. Easier to review.
    total_time_spent = sum(
        time_spent
        for tag in time_by_annotations_by_tag
        for annotation, time_spent in time_by_annotations_by_tag[tag].items()
    )

    for tag, annotations in time_by_annotations_by_tag.items():
        print(f"\n---- {tag} ----:\n", file=sys.stderr)
        for annotation, time_spent in sorted(
            annotations.items(), key=lambda item: item[1], reverse=True
        ):
            pct = time_spent / total_time_spent * 100
            print(f"{annotation}: {pct:.1f}%", file=sys.stderr)


def _others_autopct(values, total_reference):
    """Allow to override matplotlib autopct to work with a different total_reference."""

    def autopct(pct):
        actual = pct * sum(values) / 100
        return f"{actual/total_reference*100:.0f}%"

    return autopct


def main():
    """Read timew summary, output metrics and plot."""
    time_by_annotations_by_tag = parse_records(read_timew_input())
    time_spent_by_tag, time_spent_by_minor_tag = total_time_spent_by_tag(
        time_by_annotations_by_tag
    )

    _, ax1 = plt.subplots(1, 1)
    ax1.set_title("Time spent by Tag")
    wedges1, _, _ = ax1.pie(
        time_spent_by_tag.values(),
        labels=list(time_spent_by_tag.keys()),
        autopct="%1.f%%",
        textprops={"color": "w"},
    )
    annotate_pie(wedges1, ax1, list(time_spent_by_tag.keys()))

    _, ax2 = plt.subplots(1, 1)
    ax2.set_title("Time spent in 'Others'")
    total_time_spent = sum(time_spent_by_tag.values())
    custom_autopct = _others_autopct(
        list(time_spent_by_minor_tag.values()), total_time_spent
    )
    wedges2, _, _ = ax2.pie(
        time_spent_by_minor_tag.values(),
        labels=list(time_spent_by_minor_tag.keys()),
        autopct=custom_autopct,
    )
    annotate_pie(wedges2, ax2, list(time_spent_by_minor_tag.keys()))

    print_annotations(time_by_annotations_by_tag)

    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    main()

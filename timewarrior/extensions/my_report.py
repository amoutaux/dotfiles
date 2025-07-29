#!/usr/bin/env python3
import json
import random
import sys

from collections import defaultdict
from datetime import datetime

import matplotlib.pyplot as plt
import numpy as np


TOP_LEVEL_TAGS = {
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
}


# sys.stdin will look like

# color: on
# debug: off
# ...
# [
# {"id":14,"start":"20240604T110859Z","end":"20240604T112910Z","tags":["BAU","Fix"],"annotation":"Fix docker build or devpi images"},
# {"id":13,"start":"20240604T112910Z","end":"20240604T120000Z","tags":["BAU","Fix","RPGTEAM-1787","Task"],"annotation":"Rebuild all docker images - Fix failed Jobs"},
# ...
# ]


def annotate_pie(wedges, pie, labels):
    # https://matplotlib.org/stable/gallery/pie_and_polar_charts/pie_and_donut_labels.html
    bbox_props = dict(boxstyle="square,pad=0.3", fc="w", ec="k", lw=0.72)
    kw = dict(arrowprops=dict(arrowstyle="-"), bbox=bbox_props, zorder=0, va="center")

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


def read_timew_input(input_stream):
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
    time_spent = defaultdict(lambda: 0)
    annotations = defaultdict(lambda: '')

    # Rq: 'Unplanned' ne sert à rien, si y'a pas de Task c'est le cas
    for record in records:
        try:
            start = datetime.strptime(record["start"], "%Y%m%dT%H%M%SZ")
            end = datetime.strptime(record["end"], "%Y%m%dT%H%M%SZ")
            spent = (end - start).total_seconds()
            if not set(record["tags"]) & TOP_LEVEL_TAGS:
                print(f'WARNING: @{record["id"]} is missing a top level tag')
            for tag in record["tags"]:
                time_spent[tag] += spent
                if "annotation" in record and not annotations[tag]:
                    annotations[tag] = record["annotation"]
        except KeyError as exc:
            print(f'WARNING: no tag "{exc.args[0]}" for {record["id"]}')
            continue

    return (time_spent, annotations)


def main():
    records = read_timew_input(sys.stdin)
    (tags_time_spent, tags_annotations) = parse_records(records)

    # figure1
    top_tags_time_spent = {k: tags_time_spent[k] for k in TOP_LEVEL_TAGS}

    fig1, ax1 = plt.subplots(1, 1)
    wedges, texts, autotexts = ax1.pie(
        top_tags_time_spent.values(),
        labels=top_tags_time_spent.keys(),
        autopct="%1i%%",
        textprops=dict(color="w"),
    )
    annotate_pie(wedges, ax1, list(top_tags_time_spent.keys()))

    # figure 2
    rpgteam_tags_time_spent = {
        k: v for k, v in tags_time_spent.items() if k.startswith('RPGTEAM')
    }
    if len(rpgteam_tags_time_spent) == 0:
        plt.tight_layout()
        plt.show()
        return

    fig2, (ax1, ax2) = plt.subplots(1, 2)

    colors = [
        (random.uniform(0, 1), random.uniform(0, 1), random.uniform(0, 1))
        for i in range(len(rpgteam_tags_time_spent))
    ]

    wedges, texts, autotexts = ax1.pie(
        rpgteam_tags_time_spent.values(),
        labels=rpgteam_tags_time_spent.keys(),
        colors=colors,
        autopct="%1i%%",
        textprops=dict(color="w")
    )

    tasks_annotations = {
        k: v for k, v in tags_annotations.items() if k.startswith('RPGTEAM')
    }
    if len(tasks_annotations):
        cells = list(tasks_annotations.items())
        cellColours = [(color, "w") for color in colors]
        table = ax2.table(
            cellText=cells, cellColours=cellColours, loc="center"
        )
        table.auto_set_font_size(True)
        table.auto_set_column_width(col=range(len(tags_annotations)))
        ax2.axis("off")

    plt.tight_layout()
    plt.show()



if __name__ == "__main__":
    main()

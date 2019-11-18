#A bunch of methods to make bash scripting easier.


#Set colors used below
bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)

# Custom printf for headers and logging
e_header() {
    printf "\n${bold}${purple}==========  %s  ==========${reset}\n" "$@"
}

e_arrow() {
    printf "➜ $@\n"
}

e_success() {
    printf "${green}✔ %s${reset}\n" "$@"
}

e_error() {
    printf "${red}✖ %s${reset}\n" "$@"
}

e_warning() {
    printf "${tan}➜ %s${reset}\n" "$@"
}

e_underline() {
    printf "${underline}${bold}%s${reset}\n" "$@"
}

e_bold() {
    printf "${bold}%s${reset}\n" "$@"
}

e_note() {
    printf "${underline}${bold}${blue}Note:${reset}  ${blue}%s${reset}\n" "$@"
}

e_info() {
  printf "%s\n" "$@"
}

# Ask user confirmation after displaying first argument
seek_confirmation() {
  printf "\n${bold}$@${reset}"
  read -p " (y/n) " -n 1
  printf "\n"
}

# Test whether $REPLY ends with 'Y' or 'y'
is_confirmed() {
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
      return 0
    fi
    return 1
}

# Test whether command is available using 'type'. Used to check for package
# presence.
type_exists() {
    if [ $(type -P $1) ]; then
      return 0
    fi
    return 1
}

# Test whether the current directory is a Git repository
is_git_repository() {
  # Check if the current directory is in a Git repository.
  if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then
    # Check if the current directory is in .git before running git checks
    if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then
      return 0;
    fi;
  fi;
  return 1;
}

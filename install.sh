#!/usr/bin/env bash

# Exit on failure
set -e

DOTFILES_DIR=$HOME/dotfiles
DOTFILES_TARBALL_URL="https://www.github.com/amoutaux/dotfiles/tarball/macos"
DOTFILES_GIT_REMOTE="git@github.com/amoutaux/dotfiles.git"

if [[ $(uname) != 'Darwin' ]]; then
    echo "Unknown platform: only 'Linux' or 'Darwin' supported for \$uname."
    exit 1
fi

# Options
for opt in "$@"; do
    case $opt in
    '--all')
        all=true
        ;;
    '--bepo')
        bepo=true
        ;;
    '--init-git')
        init_git=true
        ;;
    '--fonts')
        fonts=true
        ;;
    '--packages')
        packages=true
        ;;
    '--symlinks')
        symlinks=true
        ;;
    '--zsh')
        zsh=true
        ;;
    '--tmux')
        tmux=true
        ;;
    *)
        printf "%s\n" "Available flags:" "" \
            "--all:          activate all flags below." \
            "--bepo:         add bepo keyboard layout." \
            "--init-git:     initialize git repository. Add origin. ⚠️ Will run \`git clean -fd\`." \
            "--fonts:        install powerline fonts." \
            "--packages:     install packages." \
            "--symlinks:     create symlinks." \
            "--zsh:          setup ZSH." \
            "--tmux:         setup Tmux." \
            ""
        printf "%s" "WARNING: to avoid installing a specific package, " \
            "remove it from the install_packages method."
        exit 1
        ;;
    esac
done

# Download the entire repository into $DOTFILES_DIR via tarball
if [[ ! -d $DOTFILES_DIR ]]; then
    curl -fsSLo "$HOME/dotfiles.tar.gz" "$DOTFILES_TARBALL_URL"
    mkdir "$DOTFILES_DIR"
    tar -zxf "$HOME/dotfiles.tar.gz" --strip-components 1 -C "$DOTFILES_DIR"
    rm -rf "$HOME/dotfiles.tar.gz"
fi

# source utils since they are needed here
source "$DOTFILES_DIR/shell/utils.sh"

install_packages() {

    if [[ ! ($packages || $all) ]]; then
        return
    fi

    if ! type_exists 'brew'; then
        e_header "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        e_bold "Updating Homebrew"
        brew update
        brew doctor
    fi

    local -a packages=(
        'bat'
        'git'
        'htop'
        'jq'
        'less' # native macos less doesn't ship with lesskey
        'most'
        'neovim'
        'npm'
        'node'
        'python3'
        'ripgrep'
        'task'
        'tig'
        'timewarrior'
        'tldr'
        'tmux'
        'tree'
        'zsh'
    )

    local -a python_packages=(
        'virtualenvwrapper'
    )

    local -a brew_cask=(
        'google-chrome'
        'iterm2'
        'brave-browser'
        'fork'
        'obsidian'
        'raycast'
        'xquartz'
    )

    e_header "Installing packages with brew..."
    for package in "${packages[@]}"; do
        brew install "$package" || e_warning "$package install failed."
    done

    e_header "Installing brew cask packages..."
    for package in "${brew_cask[@]}"; do
        brew install --cask "$package" || e_warning "$package install failed."
    done

    e_header "Installing Pyenv..."
    # symlink python3 to python since there is no /usr/local/bin/python by default
    sudo ln -nsf /usr/local/bin/python3 /usr/local/bin/python
    # pyenv is cloned manually
    if [[ ! -d "$HOME/.pyenv" ]]; then
        git clone -q https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
    fi

    if [[ -n "$VIRTUAL_ENV" ]]; then
        seek_confirmation "Virtual environment ($VIRTUAL_ENV) detected. Install python packages ?"
        if is_confirmed; then
            e_header "Installing python packages..."
            for package in "${python_packages[@]}"; do
                pip install "$package" || e_warning "$package installation failed"
            done
        fi
    else
        seek_confirmation "Not running in a virtual environment. Install python packages on system ?"
        if is_confirmed; then
            e_header "Installing python packages..."
            for package in "${python_packages[@]}"; do
                pip install --break-system-packages "$package" || e_warning "$package installation failed"
            done

        fi
    fi
}

install_fonts() {

    if [[ ! ($fonts || $all) ]]; then
        return
    fi

    e_header "Installing powerline fonts..."
    git clone https://github.com/powerline/fonts "$HOME/fonts"
    "$HOME/fonts/install.sh"
    rm -rf "$HOME/fonts"
}

init_git() {
    # Link downloaded dotfiles directory to the git repository
    if [[ ($init_git || $all) ]]; then
        e_header "Initializing git repository..."
        cd "$DOTFILES_DIR"
        if ! is_git_repository; then
            git init
            git remote add origin $DOTFILES_GIT_REMOTE
            git fetch origin master
            git reset --hard FETCH_HEAD
            git clean -fd # Remove any untracked files
            git push -u origin master || e_error "Couldn't run 'git push -u origin master'"
        else
            e_warning "Already a git repository!"
        fi
        cd -
    fi
}

setup_zsh() {

    if [[ ! ($zsh || $all) ]]; then
        return
    fi
    e_header "Setuping ZSH..."

    # Setup default shell
    seek_confirmation "Add $(which zsh) to /etc/shells and set it as default shell?"
    if is_confirmed; then
        if ! grep -Fxq "$(which zsh)" /etc/shells; then
            sudo sh -c 'echo "$(which zsh)" >> /etc/shells'
        fi
        chsh -s "$(which zsh)" "$(whoami)" || e_error "Failed to setup default shell."
    fi

    # Install oh-my-zsh
    e_bold "Installing oh-my-zsh"
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
    else
        e_warning "oh-my-zsh already installed."
    fi

    # Add zsh syntax highlighting to oh-my-zsh plugins
    e_bold "Installing zsh-syntax-highlighting plugin"
    if [[ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting"
    else
        e_warning "Zsh-syntax-highlighting already installed."
    fi

    # Install starship
    e_bold "Installing Starship"
    if [[ ! -f /usr/local/bin/starship ]]; then
        curl -sS https://starship.rs/install.sh | sh
    else
        e_warning "Starship already installed."
    fi
}

setup_tmux_plugin_manager() {

    if [[ ! ($tmux || $all) ]]; then
        return
    fi

    e_header "Setuping TPM..."
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    else
        e_warning "Tmux plugin manager already installed."
    fi
}

setup_bepo() {
    if [[ $bepo || $all ]]; then
        e_header "Installing bepo bundle..."
        sudo cp -R "$DOTFILES_DIR/bepo/fr-dvorak-bepo.bundle" "/Library/Keyboard\ Layouts"
    fi
}

create_symlinks() {

    if [[ ! ($symlinks || $all) ]]; then
        return
    fi

    e_header "Creating symlinks..."
    # Create necessary directories
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.config/karabiner"
    mkdir -p "$HOME/.config/k9s"
    mkdir -p "$HOME/.config/timewarrior"
    mkdir -p "$HOME/.local/share/timewarrior"
    mkdir -p "$HOME/.tmux/plugins"
    mkdir -p "$HOME/Library/Developer/Xcode/UserData"
    # git
    ln -nsf "$DOTFILES_DIR/git/gitignore" "$HOME/.gitignore"
    ln -nsf "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
    ln -nsf "$DOTFILES_DIR/git/tigrc" "$HOME/.tigrc"
    # karabiner
    ln -nsf "$DOTFILES_DIR/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
    # k9s
    ln -nsf "$DOTFILES_DIR/k9s/skins" "$HOME/.config/k9s/skins"
    ln -nsf "$DOTFILES_DIR/k9s/config.yaml" "$HOME/.config/k9s/config.yaml"
    ln -nsf "$DOTFILES_DIR/k9s/views.yaml" "$HOME/.config/k9s/views.yaml"
    # less
    ln -nsf "$DOTFILES_DIR/bepo/lesskey" "$HOME/.lesskey"
    # markdownlint
    ln -nsf "$DOTFILES_DIR/nvim/markdownlint.yaml" "$HOME/.markdownlint.yaml"
    # nvim
    ln -nsf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    ln -nsf "$DOTFILES_DIR/nvim/tern-config" "$HOME/.tern-config"
    # shell
    ln -nsf "$DOTFILES_DIR/shell/utils.sh" "$HOME/.utils.sh"
    # timewarrior
    ln -nsf "$DOTFILES_DIR/timewarrior/extensions" "$HOME/.config/timewarrior/extensions"
    ln -nsf "$DOTFILES_DIR/timewarrior/timewarrior.cfg" "$HOME/.config/timewarrior/timewarrior.cfg"
    ln -nsf "$DOTFILES_DIR/timewarrior/data" "$HOME/.local/share/timewarrior/data"
    # tmux
    ln -nsf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
    # virtualenvwrapper
    ln -nsf "$DOTFILES_DIR/virtualenvwrapper/postmkvirtualenv" "$WORKON_HOME/postmkvirtualenv"
    # zsh
    ln -nsf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
    ln -nsf "$DOTFILES_DIR/zsh/zshenv" "$HOME/.zshenv"
    ln -nsf "$DOTFILES_DIR/zsh/aliases" "$HOME/.aliases"
    ln -nsf "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile"
    ln -nsf "$DOTFILES_DIR/zsh/starship.toml" "$HOME/.config/starship.toml"
    # xcode
    ln -nsf "$DOTFILES_DIR/xcode/fonts" "$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
}

instructions() {
    e_header "Additional instructions..."

    if [[ ($tmux || $all) ]]; then
        e_note "TMUX: Don't forget to run 'Prefix + I' inside tmux to install tpm plugins"
    fi

    terminal_instructions="
TERMINAL: (iTerm) Check the 'Applications in terminal may access clipboard' option in chosen terminal.
TERMINAL: (iTerm) Preferences > Profiles > Keys > Right opt key : Esc+
    "
    printf '%s' "$terminal_instructions"
}

install_packages
install_fonts
create_symlinks
setup_tmux_plugin_manager
init_git
setup_zsh
setup_bepo
instructions

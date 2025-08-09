#!/usr/bin/env bash

# Exit on failure
set -e

DOTFILES_DIR=$HOME/dotfiles
DOTFILES_TARBALL_URL="https://www.github.com/amoutaux/dotfiles/tarball/master"
DOTFILES_GIT_REMOTE="git@github.com/amoutaux/dotfiles.git"

# Options
for opt in "$@"; do
    case $opt in
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

    if [[ ! $packages ]]; then
        return
    fi

    local -a packages=(
        'bat'
        'git'
        'htop'
        'jq'
        'most'
        'neovim'
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

    e_header "Installing packages..."
    read -r -p "Package installation command (ex: 'apt install'): " cmd
    for package in "${packages[@]}"; do
        $cmd "$package" || e_warning "$package installation failed"
    done

    e_header "Installing Pyenv..."
    # pyenv is cloned manually
    if [[ ! -d "$HOME/.pyenv" ]]; then
        git clone -q https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
    fi
}

install_fonts() {

    if [[ ! $fonts ]]; then
        return
    fi

    e_header "Installing powerline fonts..."
    git clone https://github.com/powerline/fonts "$HOME/fonts"
    "$HOME/fonts/install.sh"
    rm -rf "$HOME/fonts"
}

init_git() {
    # Link downloaded dotfiles directory to the git repository
    if [[ $init_git ]]; then
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

    if [[ ! $zsh ]]; then
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

    if [[ ! $tmux ]]; then
        return
    fi

    e_header "Setuping TPM..."
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    else
        e_warning "Tmux plugin manager already installed."
    fi
}

create_symlinks() {

    if [[ ! $symlinks ]]; then
        return
    fi

    e_header "Creating symlinks..."
    # Create necessary directories
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.config/k9s"
    mkdir -p "$HOME/.config/timewarrior"
    mkdir -p "$HOME/.local/share/timewarrior"
    mkdir -p "$HOME/.tmux/plugins"
    # git
    ln -nsf "$DOTFILES_DIR/git/gitignore" "$HOME/.gitignore"
    ln -nsf "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
    ln -nsf "$DOTFILES_DIR/git/tigrc" "$HOME/.tigrc"
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
    # zsh
    ln -nsf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
    ln -nsf "$DOTFILES_DIR/zsh/zshenv" "$HOME/.zshenv"
    ln -nsf "$DOTFILES_DIR/zsh/aliases" "$HOME/.aliases"
    ln -nsf "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile"
    ln -nsf "$DOTFILES_DIR/zsh/starship.toml" "$HOME/.config/starship.toml"
}

instructions() {
    e_header "Additional instructions..."

    if [[ ! $tmux ]]; then
        e_note "TMUX: Don't forget to run 'Prefix + I' inside tmux to install tpm plugins"
    fi
}

install_packages
install_fonts
create_symlinks
setup_tmux_plugin_manager
init_git
setup_zsh
instructions

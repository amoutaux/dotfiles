#!/usr/bin/env bash

# Exit on failure
set -e

DOTFILES_DIR=$HOME/dotfiles
DOTFILES_TARBALL_URL="https://www.github.com/amoutaux/dotfiles/tarball/master"
DOTFILES_GIT_REMOTE="git@github.com/amoutaux/dotfiles.git"


# Options
for opt in "$@"; do
    case $opt in
        '--bepo')
            bepo=true;;
        '--no-fonts')
            no_fonts=true;;
        '--no-apt-setup')
            no_apt_setup=true;;
        '--no-nvim')
            no_nvim=true;;
        '--no-packages')
            no_packages=true;;
        '--no-symlinks')
            no_symlinks=true;;
        '--no-zsh')
            no_zsh=true;;
        '--no-tmux')
            no_tmux=true;;
        '--init-git')
            init_git=true;;
        *)
            printf "%s\n" "Available options:" "--no-fonts" "--no-apt-setup" \
                "--no-nvim" "--no-packages" "--no-symlinks" "--no-zsh" \
                "--no-tmux" "--bepo"
            printf "%s" "WARNING: to avoid installing a specific package, " \
                "remove it from the install_packages method."
            exit 1;;
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

e_header "Dotfiles installation"

# Platform identification
if [[ "$(uname)" != "Linux" ]]; then
    echo "This script is meant for 'Linux' and you are running it from $(uname)";
    exit 1
fi
setup_apt() {

    if [[ $no_apt_setup ]]; then
        return
    fi

    e_header "apt update && apt upgrade..."
    sudo apt update && sudo apt upgrade

    e_bold "Installing build-essential & software-properties-common packages"
    local -a packages=(
        'build-essential'
        'software-properties-common'
        )
    # Install all packages
    sudo apt install -y "$( printf "%s " "${packages[@]}" )"
}

install_packages() {

    if [[ $no_packages ]]; then
        return
    fi

    local -a generic=(
        'bat'
        'exuberant-ctags'
        'git'
        'gnome-shell-extension-autohidetopbar'
        'gnome-shell-extension-caffeine'
        'gnome-shell-extension-gsconnect'
        'gnome-shell-extension-remove-dropdown-arrows'
        'gnome-shell-extensions'
        'gnome-tweaks'
        'htop'
        'jq'
        'most'
        'neovim'
        'nodejs'
        'python3'
        'python3-pip' # pip comes along with python3 on mac
        'ripgrep'
        'shellcheck'
        'task'
        'ripgrep'
        'shellcheck'
        'shfmt'
        'task'
        'terminator'
        'tig'
        'timewarrior'
        'tldr'
        'tmux'
        'tree'
        'universal-ctags'
        'xclip'
        'zsh'
    )

    local -a snap=(
        'shfmt'
    )

    # WARNING: It is important for xclip that xquartz is installed first
    setup_apt
    cmd="sudo apt install -y -qq"
    cmd2="sudo snap install"

    e_header "Installing generic packages..."
    for package in "${generic[@]}"; do
        # Brew will throw an error if a package is already installed
        $cmd $package || e_warning "$package installation failed"
    done

    e_header "Installing snap packages..."
    for package in ${snap[@]}; do
        $cmd2 $package || e_warning "$package installation failed"
    done

    e_header "Installing Pyenv..."
    # pyenv is cloned manually
    if [[ ! -d "$HOME/.pyenv" ]]; then
        git clone -q https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
    fi
}

install_powerline_fonts() {

    if [[ $no_fonts ]]; then
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
        cd "$DOTFILES_DIR"
        if ! is_git_repository; then
            e_header "Initializing git repository..."
            git init
            git remote add origin $DOTFILES_GIT_REMOTE
            git fetch origin master
            git reset --hard FETCH_HEAD
            git clean -fd # Remove any untracked files
            git push -u origin master || e_error "Couldn't run 'git push -u origin master'"
        fi
        cd -
    fi
}

setup_zsh() {

    if [[ $no_zsh ]]; then
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
}

setup_tmux_plugin_manager() {

    if [[ $no_tmux ]]; then
        return
    fi

    e_header "Setuping TPM..."
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    else
        e_warning "Tmux plugin manager already installed."
    fi
}

install_nvim_plugins() {

    if [[ $no_nvim ]]; then
        return
    fi

    if type_exists 'nvim'; then
        e_header "Installing neovim plugins..."
        nvim +UpdateRemotePlugins +PlugInstall +qall
        nvim -c "source $HOME/.config/nvim/init.vim" +qall
    else
        e_error "Cannot install neovim plugins: neovim isn't installed."
    fi
}

create_symlinks() {

    if [[ $no_symlinks ]]; then
        return
    fi

    e_header "Creating symlinks..."
    # Create necessary directories
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.config/k9s"
    mkdir -p "$HOME/.tmux/plugins"
    mkdir -p "$HOME/.ctags.d"
    # git
    ln -nsf "$DOTFILES_DIR/git/gitigno/re" "$HOME/.gitignore"
    ln -nsf "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
    ln -nsf "$DOTFILES_DIR/git/tigrc" "$HOME/.tigrc"
    # k9s
    ln -nsf "$DOTFILES_DIR/k9s" "$HOME/.config/k9s"
    # less
    ln -nsf "$DOTFILES_DIR/bepo/lesskey" "$HOME/.lesskey"
    # nvim
    ln -nsf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    ln -nsf "$DOTFILES_DIR/nvim/ctags" "$HOME/.ctags.d/default.ctags"
    ln -nsf "$DOTFILES_DIR/nvim/tern-config" "$HOME/.tern-config"
    # shell
    ln -nsf "$DOTFILES_DIR/shell/utils.sh" "$HOME/.utils.sh"
    # timewarrior
    ln -nsf "$DOTFILES_DIR/timewarrior" "$HOME/.config/timewarrior"
    # tmux
    ln -nsf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
    # zsh
    ln -nsf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
    ln -nsf "$DOTFILES_DIR/zsh/zshenv" "$HOME/.zshenv"
    ln -nsf "$DOTFILES_DIR/zsh/aliases" "$HOME/.aliases"
    ln -nsf "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile"
}

instructions() {
    e_header "Additional instructions..."

    if [[ $bepo ]]; then
        e_note "BEPO: Settings > Keyboard > Input sources > Display input sources in menu bar"
    fi
    if [[ ! $no_tmux ]]; then
        e_note "TMUX: Don't forget to run 'Prefix + I' inside tmux to install tpm plugins"
    fi

}

install_packages
install_powerline_fonts
create_symlinks
install_nvim_plugins
setup_tmux_plugin_manager
init_git
setup_zsh
instructions

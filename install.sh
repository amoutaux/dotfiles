#!/usr/bin/env bash

# Exit on failure
set -e

DOTFILES_DIR=$HOME/dotfiles
DOTFILES_TARBALL_URL="https://www.github.com/amoutaux/dotfiles/tarball/master"
DOTFILES_GIT_REMOTE="git@github.com/amoutaux/dotfiles.git"


# Options
for opt in $@; do
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
    curl -fsSLo $HOME/dotfiles.tar.gz $DOTFILES_TARBALL_URL
    mkdir $DOTFILES_DIR
    tar -zxf $HOME/dotfiles.tar.gz --strip-components 1 -C $DOTFILES_DIR
    rm -rf $HOME/dotfiles.tar.gz
fi

# source utils since they are needed here
source $DOTFILES_DIR/shell/utils.sh

e_header "Dotfiles installation"

# Platform identification
case $(uname) in
    'Linux')
        platform='linux';;
    'Darwin')
        platform='osx';;
    *)
        echo "Unknown platform: only 'Linux' or 'Darwin' supported for \$uname.";
        exit 1;;
esac

install_brew() {
    if ! type_exists 'brew'; then
        e_header "Installing Homebrew"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        e_bold "Updating Homebrew"
        brew update
        brew doctor
    fi
}

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
    sudo apt install -y $( printf "%s " "${packages[@]}" )
}

install_packages() {

    if [[ $no_packages ]]; then
        return
    fi

    local -a generic=(
        'tree'
        'most'
        'git'
        'zsh'
        'tig'
        'tmux'
        'python3'
        'neovim'
        'direnv'
        'ripgrep'
    )

    local -a linux_only=(
        'python3-pip' # pip comes along with python3 on mac
        'xclip'
        'terminator'
        'exuberant-ctags'
        'nodejs'
        'gnome-tweaks'
        'gnome-shell-extensions'
        'gnome-shell-extension-caffeine'
        'gnome-shell-extension-autohidetopbar'
        'gnome-shell-extension-gsconnect'
        'gnome-shell-extension-remove-dropdown-arrows'
    )

    local -a mac_only=(
        'node'
        'swiftlint'
        'less' # native macos less doesn't ship with lesskey
    )

    local -a brew_cask=(
        'iterm2'
        'google-chrome'
        'macdown'
        'xquartz'
        'raycast'
    )

    local -a python_packages=(
        'pipenv'
        'ipython'
        'ipdb'
        'tox'
        'pynvim'
    )
    # WARNING: It is important for xclip that xquartz is installed first
    # Setup package managers and package list based on platform
    if [[ $platform == 'osx' ]]; then
        install_brew
        cmd="brew install"
        packages=( "${generic[@]}" "${mac_only[@]}")
        e_header "Installing brew cask packages..."
        for package in ${brew_cask[@]}; do
            brew cask install $package || e_warning "$package install failed."
        done
        # there's a space in the 'package name' thus it can't be in the loop
        brew install --HEAD universal-ctags/universal-ctags/universal-ctags
    elif [[ $platform == 'linux' ]]; then
        setup_apt
        cmd="sudo apt install -y -qq"
        packages=( "${generic[@]}" "${linux_only[@]}")
    fi

    e_header "Installing generic packages..."
    for package in ${packages[@]}; do
        # Brew will throw an error if a package is already installed
        $cmd $package || e_warning "$package installation failed"
    done

    e_header "Installing Python packages..."
    # pyenv is cloned manually
    git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
    for package in ${python_packages[@]}; do
        python3 -m pip install --user $package
    done

}

install_powerline_fonts() {

    if [[ $no_fonts ]]; then
        return
    fi

    e_header "Installing powerline fonts..."
    git clone https://github.com/powerline/fonts $HOME/fonts
    $HOME/fonts/install.sh
    rm -rf $HOME/fonts
}

init_git() {
    # Link downloaded dotfiles directory to the git repository
    cd $DOTFILES_DIR
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
        chsh -s $(which zsh) $(whoami) || e_error "Failed to setup default shell."
    fi

    # Install oh-my-zsh
    e_bold "Installing oh-my-zsh"
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh
    else
        e_warning "oh-my-zsh already installed."
    fi

    # Add zsh syntax highlighting to oh-my-zsh plugins
    e_bold "Installing zsh-syntax-highlighting plugin"
    if [[ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
    else
        e_warning "Zsh-syntax-highlighting already installed."
    fi

    # Source zshrc
    zsh -c "source $HOME/.zshrc"
}

setup_tmux_plugin_manager() {

    if [[ $no_tmux ]]; then
        return
    fi

    e_header "Setuping TPM..."
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
    else
        e_warning "Tmux plugin manager already installed."
    fi
}

install_nvim_plugins() {

    if [[ $no_nvim ]]; then
        return
    fi

    if type_exists 'nvim'; then
        e_header "Installing all neovim plugins..."
        nvim +UpdateRemotePlugins +PlugInstall +qall
        nvim -c "source $HOME/.config/nvim/init.vim" +qall
    else
        e_error "Cannot install neovim plugins: neovim isn't installed."
    fi
}

setup_bepo() {
    if [[ $bepo ]]; then
        e_header "Installing bepo bundle..."
        sudo cp -R $DOTFILES_DIR/bepo/fr-dvorak-bepo.bundle /Library/Keyboard\ Layouts
        cp -R $DOTFILES_DIR/bepo/fr-dvorak-bepo.bundle $HOME/Library/Keyboard\ Layouts
    fi
}

create_symlinks() {

    if [[ $no_symlinks ]]; then
        return
    fi

    e_header "Creating symlinks..."
    # Create necessary directories
    mkdir -p $HOME/.config
    mkdir -p $HOME/.tmux/plugins
    mkdir -p $HOME/.ctags.d
    mkdir -p $HOME/Library/Developer/Xcode/UserData
    # git
    ln -nsf $DOTFILES_DIR/git/gitignore $HOME/.gitignore
    ln -nsf $DOTFILES_DIR/git/gitconfig $HOME/.gitconfig
    ln -nsf $DOTFILES_DIR/git/tigrc $HOME/.tigrc
    # nvim
    ln -nsf $DOTFILES_DIR/nvim $HOME/.config/nvim
    ln -nsf $DOTFILES_DIR/nvim/ctags $HOME/.ctags.d/default.ctags
    ln -nsf $DOTFILES_DIR/nvim/tern-config $HOME/.tern-config
    # shell
    ln -nsf $DOTFILES_DIR/shell/utils.sh $HOME/.utils.sh
    # tmux
    ln -nsf $DOTFILES_DIR/tmux/tmux.conf $HOME/.tmux.conf
    # zsh
    ln -nsf $DOTFILES_DIR/zsh/zshrc $HOME/.zshrc
    # less
    ln -nsf $DOTFILES_DIR/bepo/lesskey $HOME/.lesskey
    # xcode
    if [[ $platform == 'osx' ]]; then
        ln -nsf $DOTFILES_DIR/xcode/fonts $HOME/Library/Developer/Xcode/UserData/FontAndColorThemes
    fi
}

instructions() {
    e_header "Additional instructions..."

    if [[ $bepo ]]; then
        printf "%s\n" "BEPO: Settings > Keyboard > Input sources > Display input sources in menu bar"
    fi
    if [[ ! $no_tmux ]]; then
        printf "%s\n" "TMUX: Don't forget to run 'Prefix + I' inside tmux to install tpm plugins"
    fi

    terminal_instructions="
TERMINAL: (iTerm) Check the 'Applications in terminal may access clipboard' option in chosen terminal.
TERMINAL: (iTerm) Preferences > Profiles > Keys > Right opt key : Esc+
    "
    printf "$terminal_instructions"

    ctags_instructions="
CTAGS: Current default.ctags file is meant for universal-ctags
/!\ On Linux, exuberant-ctags was installed.
    --> ctags config file needs to be changed and save under ~/.ctags
CTAGS: Uncomment the corresponding 'ctags' alias in ~/.zshrc
    "
    printf "$ctags_instructions"

    swift_instructions="
SWIFT: Don't forget to install sourcekit-lsp for vim support
    "
    print "$swift_instructions"
}

install_packages
install_powerline_fonts
create_symlinks
install_nvim_plugins
setup_zsh
setup_tmux_plugin_manager
init_git
setup_bepo
instructions


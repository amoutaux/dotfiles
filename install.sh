#!/usr/bin/env bash

# Exit on failure
set -e

DOTFILES_DIR=$HOME/dotfiles
DOTFILES_TARBALL_URL="https://www.github.com/amoutaux/dotfiles/tarball/master"
DOTFILES_GIT_REMOTE="git@github.com:amoutaux/dotfiles.git"


# Download the entire repository into $DOTFILES_DIR via tarball
if [[ ! -d $DOTFILES_DIR ]]; then
    curl -fsSLo ~/dotfiles.tar.gz $DOTFILES_TARBALL_URL
    mkdir $DOTFILES_DIR
    tar -zxf ~/dotfiles.tar.gz --strip-components 1 -C $DOTFILES_DIR
    rm -rf ~/dotfiles.tar.gz
fi
# source utils since they are needed here
source $DOTFILES_DIR/shell/utils.sh

# Options
options=('--no-fonts --no-apt-setup')
for opt in $@; do
    case $opt in
        '--no-fonts')
            no_fonts=true;;
        '--no-apt-setup')
            no_apt_setup=true;;
        *)
            e_error "Unrecognized option $opt"
            e_info "Available options: $options"
            exit 1;;
    esac
done

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

setup_apt_get() {
    if [[ ! $no_apt_setup ]]; then
        e_header "Setuping apt-get..."
        sudo apt-get update
        sudo apt-get upgrade

        local -a packages=(
            'build-essential'
            'software-properties-common'
            )
        # Install all packages
        sudo apt-get install -y $( printf "%s " "${packages[@]}" )
    fi
}

install_packages() {

    e_header "Installing packages..."

    local -a packages=(
        'most'
        'git'
        'zsh'
        'tig'
        'tmux'
        'python3'
        'nvim'
    )

    install() {
        case $platform in
            'osx')
                cmd="brew install $1";;
            'linux')
                cmd="sudo apt-get install -y $1";;
            *)
        esac
        e_bold "$1 installation launched. Check everything goes fine."
        $cmd
    }

    # Install package if not already present
    for package in ${packages[@]}; do
        if ! type_exists $package; then
            if [[ $package == 'nvim' ]]; then
                install 'neovim'
            else
                install $package
            fi
        else
            e_warning "$package already installed."
        fi
    done
}

install_powerline_fonts() {
    if [[ ! $no_fonts ]]; then
        e_header "Installing powerline fonts..."
        git clone https://github.com/powerline/fonts ~/fonts
        ~/fonts/install.sh
        rm -rf ~/fonts
    else
        e_warning "Powerline fonts were not installed."
    fi
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
    fi
}

# Install/Setup package manager
if [[ $platform == 'osx' ]]; then
    install_brew
elif [[ $platform == 'linux' ]]; then
    setup_apt_get
fi

# Install packages
install_packages

# Install powerline fonts
install_powerline_fonts

# Create symlinks
# git
ln -nsf $DOTFILES_DIR/git/gitignore ~/.gitignore
ln -nsf $DOTFILES_DIR/git/gitconfig ~/.gitconfig
ln -nsf $DOTFILES_DIR/git/tigrc ~/.tigrc
# nvim
ln -nsf $DOTFILES_DIR/nvim ~/.config/nvim
# shell
ln -nsf $DOTFILES_DIR/shell/utils.sh ~/.utils.sh
#tmux
ln -nsf $DOTFILES_DIR/tmux/tmux.conf ~/.tmux.conf
# zsh
ln -nsf $DOTFILES_DIR/zsh/zshrc ~/.zshrc

# Set zsh as default shell
sudo chsh -s /usr/bin/zsh
# Add zsh syntax highlighting to oh-my-zsh plugins
if [[ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
else
    e_warning "Zsh-syntax-highlighting already installed."
fi
# Source zshrc
zsh -c "source ~/.zshrc"

# Install neovim plugins
if type_exists 'nvim'; then
    e_header "Installing all neovim plugins..."
    nvim +UpdateRemotePlugins +PlugInstall +qall
    nvim -c "source ~/.config/nvim/init.vim" +qall
else
    e_error "Cannot install neovim plugins: neovim isn't installed."
fi

init_git


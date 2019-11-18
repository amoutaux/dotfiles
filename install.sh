#!/usr/bin/env bash
source ./shell/utils.sh

e_header "Dotfiles installation."

# Exit on failure
set -e

DOTFILES_DIR=~/dotfiles
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
        'neovim'
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
        if [[ $package == 'neovim' ]]; then
            if ! type_exists 'nvim'; then
                install $package
            fi
        elif ! type_exists $package; then
            install $package
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
ln -nsf $DOTFILES_DIR/nvim ~/.config/nvim
ln -nsf $DOTFILES_DIR/git/gitignore ~/.gitignore
ln -nsf $DOTFILES_DIR/git/gitconfig ~/.gitconfig
ln -nsf $DOTFILES_DIR/git/tigrc ~/.tigrc
ln -nsf $DOTFILES_DIR/zsh/zshrc ~/.zshrc

# Add zsh syntax highlighting to oh-my-zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting


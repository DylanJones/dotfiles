#!/bin/zsh

# even though the shebang *says* zsh, make sure its actually using zsh
if [ -z "$ZSH_VERSION" ]; then
    echo "Doesn't look like you're using zsh..."
    echo "Please install zsh and then re-run this script using zsh"
    exit 1
fi

INSTALL_PATH="$(realpath $(dirname $0))"
USER="$(whoami)"

# do the config symlinks

TO_INSTALL=(tmux.conf i3 powerline_config zshrc vim oh-my-zsh zsh-syntax-highlighting)
TO_PATHS=(~/.tmux.conf ~/.i3 ~/.config/powerline ~/.zshrc ~/.vim ~/.oh-my-zsh ~/.zsh-syntax-highlighting)

for i in {1..${#TO_INSTALL}}; do
    if [ -f "${TO_PATHS[i]}" ]; then
        rm -ri "${TO_PATHS[i]}"
    fi
    if ! [ -f "${TO_PATHS[i]}" ]; then
        mkdir -p "$(dirname ${TO_PATHS[i]})"
        ln -s "$INSTALL_PATH/${TO_INSTALL[i]}" "${TO_PATHS[i]}"
    fi
done

# clone any sub-repos that need to be cloned
cd "$INSTALL_PATH"
git submodule update --init --recursive

# install distro-specific packages
# check for sudo access first
if sudo -l >/dev/null; then
    RELEASE_STR="$(tr '[:upper:]' '[:lower:]' < /etc/issue)"

    case "$RELEASE_STR" in
        *debian*|*ubuntu*|*raspbian* )
            # do apt stuff
            sudo apt install -y python3 python3-pip python3-dev build-essential zsh cmake tmux vim
            ;;
        *arch* )
            # do arch stuff
            sudo pacman -S --noconfirm --needed python-pip base-devel zsh git cmake tmux vim
            ;;
    esac
else
    echo "You don't have sudo privelages!"
    echo "Hopefully everything you need is installed"
    echo "Required packages: python3, pip, some compiler, cmake, git, tmux, vim"
fi

# install pip packages
pip install --user thefuck git+git://github.com/powerline/powerline

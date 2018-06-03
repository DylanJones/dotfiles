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
TO_INSTALL=(tmux.conf i3 powerline_config zshrc vim oh-my-zsh zsh-syntax-highlighting powerline-daemon.service aliases)
TO_PATHS=(~/.tmux.conf ~/.i3 ~/.config/powerline ~/.zshrc ~/.vim ~/.oh-my-zsh ~/.zsh-syntax-highlighting ~/.config/systemd/user/powerline-daemon.service ~/.aliases)

for i in {1..${#TO_INSTALL}}; do
    if [ -f "${TO_PATHS[i]}" ] || [ -d "${TO_PATHS[i]}" ]; then
        if [ -f "$INSTALL_PATH/overwrite" ]; then
            rm "${TO_PATHS[i]}"
        else
            rm -ri "${TO_PATHS[i]}"
        fi
    fi
    if ! [ -f "${TO_PATHS[i]}" ]; then
        mkdir -p "$(dirname ${TO_PATHS[i]})"
        ln -sfT "$INSTALL_PATH/${TO_INSTALL[i]}" "${TO_PATHS[i]}"
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
    echo
    echo "You don't have sudo privelages!"
    echo "Hopefully everything you need is installed"
    echo "Required packages: python3, pip, some compiler, cmake, git, tmux, vim"
    echo
fi


# install pip packages
pip3 install --user thefuck git+git://github.com/powerline/powerline

# If there are any references to python3.6, change them in case we have an old python version
PY_VER="$(python3 -c "from sys import version_info as vi; print('python'+str(vi[0])+'.'+str(vi[1]))")"
if [[ "$PY_VER" != "python3.6"  ]]; then
    echo "Old python detected ($PY_VER), changing references to reflect that"
    cd "$INSTALL_PATH"
    find -type f -not -name install.sh -exec sed -i "s/python3\\.6/$PY_VER/g" {} \;
fi

# change shell to zsh
echo "Changing default shell - enter password and /bin/zsh"
chsh

# install and enable powerline-daemon systemd service
systemctl --user daemon-reload
systemctl --user enable powerline-daemon
systemctl --user start powerline-daemon

# Done: record that we already finished so we have permission to overwrite in future
echo yes > "$INSTALL_PATH/overwrite"

echo "Done installing custom config!"

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
TO_INSTALL=(bin tmux.conf i3 powerline_config zshrc vim oh-my-zsh zsh-syntax-highlighting powerline-daemon.service aliases Xmodmaprc)
TO_PATHS=(~/bin ~/.tmux.conf ~/.i3 ~/.config/powerline ~/.zshrc ~/.vim ~/.oh-my-zsh ~/.zsh-syntax-highlighting ~/.config/systemd/user/powerline-daemon.service ~/.aliases ~/.Xmodmaprc)

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
    # RELEASE_STR="$(tr '[:upper:]' '[:lower:]' < /etc/issue)"
    . /etc/os-release # only works w/ systemd

    case "$ID" in
        *debian*|*ubuntu*|*raspbian* )
            # do apt stuff
            sudo apt install -y python3 python3-pip python3-dev build-essential zsh cmake tmux vim
            ;;
        *arch* )
            # do arch stuff
            sudo pacman -S --noconfirm --needed python-pip base-devel zsh git cmake tmux vim
            ;;
        *centos* )
            # do centos stuff
            sudo yum -y install epel-release
            sudo yum -y install python36-pip git zsh vim tmux
            sudo yum -y groupinstall "Development Tools"
            sudo pip3.6 install --upgrade pip # this fixes pip3 to point to pip3.6
            sudo sh -c 'echo "export PATH=/usr/local/bin:$PATH >> /etc/profile"' # make root be able to use pip3
            ;;
        * )
            echo "Unrecognized distro - you're on your own :("
    esac
else
    echo
    echo "You don't have sudo privelages!"
    echo "Hopefully everything you need is installed"
    echo "Required packages: python3, pip, some compiler, cmake, git, tmux, vim"
    echo
fi


# install pip packages
pip3 install --user thefuck powerline-status

# Create the python symlink to be compatible with old pythons
PY_VER="$(python3 -c "from sys import version_info as vi; print('python'+str(vi[0])+'.'+str(vi[1]))")"
mkdir -p ~/.local/lib
ln -s ~/.local/lib/$PY_VER ~/.local/lib/python3

# change shell to zsh
echo "Changing default shell - enter password"
chsh -s '/bin/zsh'

# install and enable powerline-daemon systemd service
systemctl --user daemon-reload
systemctl --user enable powerline-daemon
systemctl --user start powerline-daemon

# Done: record that we already finished so we have permission to overwrite in future
echo yes > "$INSTALL_PATH/overwrite"

echo "Done installing custom config!"

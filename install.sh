#!/bin/bash

echo "TODO: actually make the fish symlinks :/"
# also: set -U EDITOR vim
#       set -U ????
#       uhh, maybe just like, copy the uvars or somethihng?
exit

INSTALL_PATH="$(realpath $(dirname $0))"
USER="$(whoami)"

# do the config symlinks
TO_INSTALL=(bin tmux.conf i3 powerline_config vim powerline-daemon.service)
TO_PATHS=(~/bin ~/.tmux.conf ~/.i3 ~/.config/powerline ~/.vim ~/.config/systemd/user/powerline-daemon.service)

for i in $(seq 1 ${#TO_INSTALL[@]}); do
    if [ -f "${TO_PATHS[i]}" ] || [ -d "${TO_PATHS[i]}" ]; then
        if [ -f "$INSTALL_PATH/overwrite" ]; then
            echo rm "${TO_PATHS[i]}"
        else
            echo rm -ri "${TO_PATHS[i]}"
        fi
    fi
    if ! [ -f "${TO_PATHS[i]}" ]; then
        echo mkdir -p "$(dirname ${TO_PATHS[i]})"
        echo ln -sfT "$INSTALL_PATH/${TO_INSTALL[i]}" "${TO_PATHS[i]}"
    fi
done

exit 1

# clone any sub-repos that need to be cloned
cd "$INSTALL_PATH"
git submodule update --init --recursive

# install distro-specific packages
# check for sudo access first
if sudo -l >/dev/null; then
    . /etc/os-release # only works w/ systemd

    case "$ID" in
        *debian*|*ubuntu*|*raspbian* )
            # do apt stuff
            sudo apt install -y python3 python3-pip python3-dev build-essential cmake tmux vim fish
            ;;
        *arch* )
            # do arch stuff
            sudo pacman -S --noconfirm --needed python-pip base-devel git cmake tmux vim fish
            ;;
        *centos* )
            # do centos stuff
            echo -e '\n*** Just a fair warning, this centos support is uuber janky ***\n'
            sudo yum -y install epel-release
            sudo yum -y install python36-pip git vim tmux fish
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
pip3 install --user powerline-status i3-py

# Create the python symlink to be compatible with old pythons
PY_VER="$(python3 -c "from sys import version_info as vi; print('python'+str(vi[0])+'.'+str(vi[1]))")"
mkdir -p ~/.local/lib
ln -s ~/.local/lib/$PY_VER ~/.local/lib/python3

# change shell to fish
echo "Changing default shell - enter password"
chsh -s '/bin/fish'

# install and enable powerline-daemon systemd service
systemctl --user daemon-reload
systemctl --user enable powerline-daemon
systemctl --user start powerline-daemon

# Done: record that we already finished so we have permission to overwrite in future
echo yes > "$INSTALL_PATH/overwrite"

echo "Done installing custom config!"

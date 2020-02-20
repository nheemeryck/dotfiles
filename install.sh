#!/bin/sh

FORCE_INSTALL=0
INSTALL=0

usage() {
    cat<<EOF
Usage: $(basename $0) [OPTIONS] <command>

Options:
  -y        Assume yes
  -h        Show this help message
EOF
}

check_and_backup() {
	local file=$1

	if [ -z $file ]; then
		exit 1
	fi

	if [ -L $file ]; then
		rm $file
	elif [ -f $file ]; then
		mv $file $file.bak
	fi
}

while getopts "hvy" option; do
	case ${option} in
		y)
			FORCE_INSTALL=1
			;;
		h)
			usage; exit 0
			;;
		*)
			echo "Unknown option" >&2; exit 1
			;;
	esac
done

for file in $(find $(dirname $0) -maxdepth 1 \
	! -iname ".*" ! -iname `basename $0` -exec basename {} \;)
do
	dotfile=".$(basename $file)"
	check_and_backup $HOME/$dotfile
	echo "Symlinking $file to $HOME/$dotfile"
	ln -s $(dirname `readlink -f $0`)/$file $HOME/$dotfile
done

if [ ${FORCE_INSTALL} -ne 1 ]; then
	echo -n "Install VIM/NEOVIM compatibility (y/N)? "
	read answer
	echo ${answer} | grep -iq "^y"
	[ $? -eq 0 ] && INSTALL=1 || INSTALL=0
fi

if [ ${FORCE_INSTALL} -eq 1 ] || [ ${INSTALL} -eq 1 ]; then

	if [ ! -d $HOME/.vim ]; then
		mkdir -p $HOME/.vim
	fi

	if [ ! -d $HOME/.config ]; then
		mkdir -p $HOME/.config
	fi

	check_and_backup $HOME/.vim/init.vim
	ln -s $HOME/.vimrc $HOME/.vim/init.vim

	check_and_backup $HOME/.config/nvim
	ln -s $HOME/.vim $HOME/.config/nvim
fi

if [ ${FORCE_INSTALL} -ne 1 ]; then
	echo -n "Install Powerline symbols (y/N)? "
	read answer
	echo ${answer} | grep -iq "^y"
	[ $? -eq 0 ] && INSTALL=1 || INSTALL=0
fi

if [ ${FORCE_INSTALL} -eq 1 ] || [ ${INSTALL} -eq 1 ]; then

	if [ ! -d $HOME/.local/share/fonts ]; then
		mkdir -p $HOME/.local/share/fonts
	fi

	if [ ! -d $HOME/.config/fontconfig/conf.d ]; then
		mkdir -p $HOME/.config/fontconfig/conf.d
	fi

	wget -O /tmp/PowerlineSymbols.otf \
	https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf \

	if [ $? -eq 0 ]; then
		mv /tmp/PowerlineSymbols.otf $HOME/.local/share/fonts/
		fc-cache -vf ~/.local/share/fonts/
	else
		echo "Fail to retrieve PowerlineSymbols.otf"
		exit 1
	fi

	wget -O /tmp/10-powerline-symbols.conf \
	https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf \

	if [ $? -eq 0 ]; then
		mv /tmp/10-powerline-symbols.conf \
		$HOME/.config/fontconfig/conf.d/
	else
		echo "Fail to 10-powerline-symbols.conf"
		exit 1
	fi
fi

if [ ${FORCE_INSTALL} -ne 1 ]; then
	echo -n "Install Antigen (y/N)? "
	read answer
	echo ${answer} | grep -iq "^y"
	[ $? -eq 0 ] && INSTALL=1 || INSTALL=0
fi

if [ ${FORCE_INSTALL} -eq 1 ] || [ ${INSTALL} -eq 1 ]; then

	if [ -e $HOME/.antigen ]; then
		rm -rf $HOME/.antigen
	fi

	git clone https://github.com/zsh-users/antigen.git ~/.antigen
	if [ $? -eq 0 ]; then
		cd $HOME/.antigen && \
		./configure && \
		make
	fi

fi

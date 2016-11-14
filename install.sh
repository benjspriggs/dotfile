#!/bin/bash
# install.sh
# install the current dotfiles to 
# the current user's home directory

echo '#!/bin/bash
GIT_HOME="" ' > ~/paths.sh

all=( 'bash/bashrc' 'bash/bash_alias' 'vim/viminfo' 'vim/vimrc' )
# move each of the files in the
# directory to backup files
# TODO: allow merge between existing files and repo files
DIR=$(pwd)

for f in ${all[@]}
do
	pre=$HOME/.
	old_path=$pre$( basename $f)
	rep_path=$DIR/$f
	mv -n $old_path $old_path\.bak
	ln -fns $rep_path $old_path 2>/dev/null
done

# install pathogen
[[ ! -e ~/.vim/autoload/pathogen.vim ]] && mkdir -p ~/.vim/autoload ~/.vim/bundle &&
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# install vim sline
[[ ! -e ~/.vim/bundle/vim-slime ]] && git clone https://github.com/jpalardy/vim-slime ~/.vim/bundle/vim-slime
# install vim table mode
[[ ! -e ~/.vim/bundle/vim-table-mode ]] && git clone https://github.com/dhruvasagar/vim-table-mode ~/.vim/bundle/vim-table-mode
# install ccimpl.vim
[[ ! -e ~/.vim/plugin/ccimpl ]] && git clone https://github.com/vim-scripts/ccimpl.vim ~/.vim/plugin/ccimpl

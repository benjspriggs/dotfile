#!/bin/bash
# install.sh
# install the current dotfiles to 
# the current user's home directory

[[ -z ~/paths.sh ]] && echo '#!/bin/bash
# Make sure GIT_HOME is a fully expanded path
GIT_HOME="" ' > ~/paths.sh

all=( 'bash/bashrc' 'bash/bash_aliases' 'vim/viminfo' 'vim/vimrc' )
# move each of the files in the
# directory to backup files
# TODO: allow merge between existing files and repo files
DIR=$(pwd)

gh () {
  [[ ! -e "$2"/"$(basename $1)" ]] || return 1
  git clone https://github.com/"$1" "$2"/"$(basename $1)"
}

for f in ${all[@]}
do
  pre=$HOME/.
  old_path=$pre$( basename $f )
  rep_path=$DIR/$f
  mv -n $old_path $old_path\.bak
  ln -fns $rep_path $old_path 2>/dev/null
done

# install pathogen
[[ ! -e ~/.vim/autoload/pathogen.vim ]] && mkdir -p ~/.vim/autoload ~/.vim/bundle &&
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# install vim sline
gh jpalardy/vim-slime ~/.vim/bundle
# install vim table mode
gh dhruvasagar/vim-table-mode ~/.vim/bundle
# install ccimpl.vim
gh vim-scripts/ccimpl.vim ~/.vim/plugin
# install surround.vim
gh tpope/vim-surround ~/.vim/bundle
# install vim-easy-align
gh junegunn/vim-easy-align ~/.vim/bundle

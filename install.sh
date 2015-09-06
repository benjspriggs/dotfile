#!/bin/bash
# install.sh
# install the current dotfiles to 
# the current user's home directory

all=( 'bash/bashrc' 'vim/viminfo' 'vim/vimrc' )
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
  ln -ns $rep_path $old_path 2>/dev/null
done

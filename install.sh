#!/bin/bash
# install.sh
# install the current dotfiles to 
# the current user's home directory

if [[ ! -e ~/paths.sh ]]; then
  echo "#!/bin/bash
  # Make sure GIT_HOME is a fully expanded path
  GIT_HOME=\"$path\"" > ~/paths.sh
  vim ~/paths.sh
fi


all=( 
'bash/bashrc'
'bash/bash_aliases'
'vim/viminfo'
'vim/vimrc'
'tmux/tmux.conf'
'git/gitconfig'
'zsh/zshrc'
)

# move each of the files in the
# directory to backup files
# TODO: allow merge between existing files and repo files
DIR=$(pwd)

gh () {
  [[ ! -e "$2"/"$(basename $1)" ]] || return 1
  git clone https://github.com/"$1" "$2"/"$(basename $1)"
}

# link and copy files around in home
for f in ${all[@]}
do
  pre=$HOME/.
  old_path=$pre$( basename $f )
  rep_path=$DIR/$f
  echo "Backing up '$old_path'..."
  mv -n $old_path $old_path\.bak
  echo "Linking up '$old_path' to '$rep_path'..."
  ln -fns $rep_path $old_path
done

# install gitk and git-gui
sudo apt-get install -y gitk git-gui
# install zsh
sudo apt-get install -y zsh
# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# install pathogen
[[ ! -e ~/.vim/autoload/pathogen.vim ]] && mkdir -p ~/.vim/autoload ~/.vim/bundle &&
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

## VIM
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

## TMUX
# install tmux-plugin-manager
gh tmux-plugins/tpm ~/.tmux/plugins

#!/bin/bash
# install.sh
# install the current dotfiles to 
# the current user's home directory

# we need to set the right vim home prefix
VIM_PREFIX=''
if [[ "$(uname -s)" =~ /CYGWIN*/ ]]; then
  VIM_PREFIX='vimfiles'
else
  VIM_PREFIX='.vim'
fi

if [[ ! -e ~/paths.sh ]]; then
echo "#!/bin/bash
# Make sure GIT_HOME is a fully expanded path
GIT_HOME=\"$path\"
BOOSTNOTE_HOME=\"$path\"
eval `keychain id_rsa`
" > ~/paths.sh
  vim ~/paths.sh
fi


all=( 
'bash/bashrc'
'bash/bash_aliases'
'vim/vimrc'
'tmux/tmux.conf'
'git/gitconfig'
'git/gitignore'
'zsh/zshrc'
'xinit/Xclients'
)

# move each of the files in the
# directory to backup files
DIR=$(pwd)

gh () {
  default=~/$VIM_PREFIX/bundle
  [[ ! -e "${2-$default}"/"$(basename $1)" ]] || return 1
  git clone https://github.com/"$1" "${2-$default}"/"$(basename $1)"
}

install-apt () {
dpkg -s $* > /dev/null || sudo apt install -y $*
}

install-yum () {
sudo yum install -y $*
}

install-brew () {
brew install -y $*
}

ensure-brew () {
echo "Ensuring brew is installed on this system..."
if [ ! -x "$(command -v brew)" ]; then
  echo "Installing brew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
}

detect-and-install () {
if [ -f /etc/debian_version ]; then
  echo "Installing using apt..."
  install-apt "$*" libncurses5-dev
elif [ -f /etc/redhat-release ]; then
  echo "Installing using yum..."
  install-yum "$*" ncurses-devel
elif [ "$(uname -s)" = 'Darwin' ]; then
  ensure-brew
  echo "Installing using brew..."
  install-brew "$*"
fi
}

# attempts to mkdir with sudo
# if we don't have access to home
# for whatever reason
smkdir () {
  mkdir $* || sudo mkdir $*
}

if [ ! -e $HOME/$VIM_PREFIX ]; then
  echo Creating vim prefix at $HOME/$VIM_PREFIX...
  smkdir -p $HOME/$VIM_PREFIX
fi

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

# install gitk and git-gui, zsh
detect-and-install keychain zsh curl vim tmux pkg-config

# install oh-my-zsh
OHMYZSH_INSTALL_LOC=https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh

[[ ! -e ~/.oh-my-zsh ]] && 
sh -c "$(curl -fsSL $OHMYZSH_INSTALL_LOC)"
# install pathogen
[[ ! -e ~/$VIM_PREFIX/autoload/pathogen.vim ]] &&
  smkdir -p ~/$VIM_PREFIX/autoload ~/$VIM_PREFIX/bundle &&
  curl -LSso ~/$VIM_PREFIX/autoload/pathogen.vim https://tpo.pe/pathogen.vim

## VIM
# install vim slime
gh jpalardy/vim-slime
# install simpylfold
gh tmhedberg/Simpylfold
# install vim table mode
gh dhruvasagar/vim-table-mode
# install ccimpl.vim
gh vim-scripts/ccimpl.vim ~/.vim/plugin
# install surround.vim
gh tpope/vim-surround
# install vim-easy-align
gh junegunn/vim-easy-align
# install vim-fugitive
gh tpope/vim-fugitive
# install vim-tex-fold
gh matze/vim-tex-fold
# install vim-yaml
gh avakhov/vim-yaml
# indentline
gh Yggdroot/indentLine
# vim-go
gh fatih/vim-go

## TMUX
# install tmux-plugin-manager
gh tmux-plugins/tpm ~/.tmux/plugins
# install tmux-save to bin
gh zsoltf/tmux-save-sessions ~/bin
if [ ! -e ~/bin/tss ]; then
  pushd .
  cd ~/bin
  ls tmux-save-sessions
  ln -s tmux-save-sessions/tmux-save-session.sh tss
  popd
fi

# install progress to bin
gh Xfennec/progress '~/.local/share'
if [ ! -e ~/bin/progress ]; then
  pushd .
  cd '~/.local/share/progress'
  sudo make && sudo make install
  popd
fi

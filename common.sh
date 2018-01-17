#!/bin/sh
# common functions between different login shells

# sync boostnote directory
sync_boostnote() {
  cd $BOOSTNOTE_HOME
  git add --all
  git commit -am "Update `date -u`"
  git push origin
  cd -
}

# strip prefixes from
# filenames in the current directory
strip_prefix() {
  # requires prefix to strip
  [[ -z "$1" ]] && exit 1

  for file in *;
  do mv "$file" "${file#"$1"}";
  done
}

# cleans up control characters
# in most script usages
clean_script() {
  [[ -z "$1" ]] && return 1
  # courtesy of unixmonkey3987 at:
  # https://www.commandlinefu.com/commands/view/2318/fix-a-typescript-file-created-by-the-script-program-to-remove-control-characters
  cat "$1" | perl -pe 's/\e([^\[\]]|\[.*?[a-zA-Z]|\].*?\a)//g' | col -b > "$1-processed"
  mv "$1-processed" "$1"
}

# clone something from github
gh () {
  if [[ -z "$1" ]]; then
    >&2 echo -e "Usage: \tgh [repo] [folder]\n\t[repo] can be a fully qualified name, or the short name\n\t[folder] is optional"
    return 1
  fi

  local prefix='git@github.com:'

  # clone based on arguments
  if [[ -z "$2" ]] && [[ "$1" =~ : ]]; then
    git clone $prefix"$1"
  elif [[ ! -z "$2" ]] && [[ ! "$1" =~ : ]]; then
    git clone $prefix"$1"
  elif [[ -z "$2" ]] && [[ ! "$1" =~ : ]]; then
    git clone $prefix"$1"
  else
    git clone $prefix"$1" "$2"
  fi
}

# opening a subshell for testing something
wonder () {
  f=${1:-`mktemp -d`}

  # open subshell
  bash --rcfile <(
  echo "mkdir -p "$f" || rm -rf "$f/";
  cd "$f";
  PS1='testing subshell $ ';"
  ) -i
  rm -rf "$f" # clean up
}

# xclip to clipboard function
xclip-cb () {
  xclip -selection clipboard -i $@
}

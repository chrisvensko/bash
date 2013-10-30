echo $HOME;
SCRIPTDIR=$(dirname $(pwd -P $0)/${0#\.\/})

setup_bashrc() {
	# todo - see if .bashrc already exists
	echo "Setting up .bashrc"
	ln -s $SCRIPTDIR/bashrc $HOME/.bashrc
  ln -s $HOME/.bash_profile $HOME/.bashrc
}

setup_vimrc() {
	# todo - see if .vimrc already exists
	echo "Setting up .vimrc"
	ln -s $SCRIPTDIR/vimrc $HOME/.vimrc
}

setup_gitconfig() {
  # todo - see if .gitconfig already exists
  echo "Setting up .gitconfig"
  ln -s $SCRIPTDIR/gitconfig $HOME/.gitconfig
}

setup_tmux() {
  # todo - see if .tmux.conf already exists
  echo "Setting up .tmux.conf"
  ln -s $SCRIPTDIR/tmux.conf $HOME/.tmux.conf

  ln -s $SCRIPTDIR/tmux-completion $HOME/tmux-completion
}


setup_all() {
	setup_bashrc
	setup_vimrc
  setup_gitconfig
  setup_tmux
}

setup_all

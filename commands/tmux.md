# Awesome Tmux Commands

** Note: This is NOT designed to help beginners get started with TMUX

** Note: I have bound Ctrl-a as my prefix, but the default is Ctrl-b

## Moving windows

__Between Sessions__

If you are viewing the window you want to move, you can just specify where you want it moved  [^1](http://stackoverflow.com/questions/3094946/move-window-between-tmux-clients) :

	[Prefix] :move-window -t <other_session_name>

## Disconnecting other clients

If you find that you have a client session that didn't disconnect correctly, you can disconnect with:

  tmux attach -d -t <session_name>


[^1]: http://stackoverflow.com/questions/3094946/move-window-between-tmux-clients "Reference"

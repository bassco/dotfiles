# less - switches and keybindings

I like the adjustable horizontal scroll option, i.e. prepend the left/right arrow key with a number and less will scroll that number of columns from then on, works best with chop-lines option -S.

less reads command line switches from the $LESS variable on startup, here are my preferred switches:

$ echo $LESS
-FXMQRSi
-F or --quit-if-one-screen
Causes less to automatically exit if the entire file can be displayed on the first screen.
-M more verbose status line.
-Q no bells.
-R don't convert raw input, lets escape sequences be interpreted.
-S disable line wrapping.
-X or --no-init
Disables sending the termcap initialization and deinitialization strings to the terminal. This is sometimes desirable if the deinitialization string does something unnecessary, like clearing the screen.
-i case insensitive searching.

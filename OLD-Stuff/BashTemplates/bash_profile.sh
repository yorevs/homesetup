# .bash_profile

HOME=${HOME:-~/}

# Terminal colors

if test "$(uname -s)" = "Linux"
then
    # For Linux
    export GREP_OPTIONS='--color=auto'
    export LS_OPTIONS="-A -N --color=auto -T 0"
    export LS_COLORS="no=00:fi=00:di=01;34:ln=00;36:mi=05;33:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=05;33:ex=00;32:*.deb=00;31:*.sh=00;31:"
    # Prompt style
	export PS1="\u@\h:\w$ "
	echo "Linux profile loaded" 
elif test "$(uname -s)" = "Darwin"
then
    # For Mac
    export CLICOLOR=1
    export LSCOLORS="GxdxhxDxcxxxxxCxCxCxCx"
    export PS1="\u@\h:\w$ "
    echo "MacOS profile loaded"
elif test "$(uname -s | cut -d '-' -f1 )" = "MINGW64_NT"
then
    # For Windows ( MinGw )
    export GREP_OPTIONS='--color=auto'
    export LS_OPTIONS="-F --color --show-control-chars"
    export LS_COLORS="no=00:fi=00:di=01;34:ln=00;36:mi=05;33:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=05;33:ex=00;32:*.deb=00;31:*.sh=00;31:"
    export PS1="\w$ "
    echo "Windows profile loaded"
fi

unset USERNAME

# Activate aliases
test -f $HOME/.bash_aliases && source $HOME/.bash_aliases
test -f $HOME/.bash_env && source $HOME/.bash_env

##
# Your previous /Users/hugo/.bash_profile file was backed up as /Users/hugo/.bash_profile.macports-saved_2014-09-10_at_08:41:51
##

# MacPorts Installer addition on 2014-09-10_at_08:41:51: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


##
# Your previous /Users/hugo/.bash_profile file was backed up as /Users/hugo/.bash_profile.macports-saved_2014-11-17_at_04:59:45
##

# MacPorts Installer addition on 2014-11-17_at_04:59:45: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


##
# Your previous /Users/hugo/.bash_profile file was backed up as /Users/hugo/.bash_profile.macports-saved_2016-09-21_at_20:43:22
##

# MacPorts Installer addition on 2016-09-21_at_20:43:22: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


if test "$(uname -s)" = "Linux"
then
    # For Linux
    alias ls='ls --color=auto -h'
    alias myIP='ifconfig | grep "inet addr" | tail -n 1 | sed "s_.*inet [a-z]*:\(.*\)  Bcast.*_\1_g"'
    alias apt-get='sudo apt-get'
elif test "$(uname -s)" = "Darwin"
then
    # For Mac
    alias ls='ls -G'
    alias myIP='ifconfig | grep "inet" | grep "broadcast" | sed "s_.*inet \(.*\) netmask.*_\1_g"'
    alias wget='curl -O'
    alias cleands='f=`find . -type f -name ".DS_Store*"`;test -n "$f" && rm $f'
fi

if ! test "$(uname -s | cut -d '-' -f1 )" = "MINGW64_NT"
then
	# There is no sudo for windows
	alias vi='sudo vim'
	alias service='sudo service'
	alias arota='sudo route -n add 192.168.0.0/20 192.168.20.97'
else
    # For Windows ( MinGw )
	alias ls='ls -F --color --show-control-chars'
fi

alias ll='ls -la'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --color=auto'
alias onditem='ssh -L 3306:localhost:3306 -L 8080:localhost:8080 -L 4848:localhost:4848 ubuntu@onditem.com.br'
alias savetheworld='ssh -L 3306:localhost:3306 -L 8080:localhost:8080 -L 4848:localhost:4848 ubuntu@savetheworld'


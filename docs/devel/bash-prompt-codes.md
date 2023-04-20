Bash has four prompt strings that can be customized:

PS0 is displayed after each command, before any output.
PS1 is the primary prompt which is displayed before each command, thus it is the one most people customize.
PS2 is the secondary prompt displayed when a command needs more input (e.g. a multi-line command).
PS3 is not very commonly used. It is the prompt displayed for Bash's select built-in which displays interactive menus. Unlike the other prompts, it does not expand Bash escape sequences. Usually you would customize it in the script where the select is used rather than in your .bashrc.
PS4 is also not commonly used. It is displayed when debugging bash scripts to indicate levels of indirection. The first character is repeated to indicate deeper levels.

| Code       | Description                                                                                                                                                                         |
|------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| \a         | an ASCII bell character (07)                                                                                                                                                        |
| \d         | the date in "Weekday Month Date" format (e.g., "Tue May 26")                                                                                                                        |
| \D{format} | the  format  is  passed to strftime(3) and the result is inserted into the prompt string; an empty format results in a locale-specific time representation. The braces are required |
| \e         | an ASCII escape character (033)                                                                                                                                                     |
| \h         | the hostname up to the first ‘.’                                                                                                                                                    |
| \H         | the hostname                                                                                                                                                                        |
| \j         | the number of jobs currently managed by the shell                                                                                                                                   |
| \l         | the basename of the shell’s terminal device name                                                                                                                                    |
| \n         | newline                                                                                                                                                                             |
| \r         | carriage return                                                                                                                                                                     |
| \s         | the name of the shell, the basename of $0 (the portion following the final slash)                                                                                                   |
| \t         | the current time in 24-hour HH:MM:SS format                                                                                                                                         |
| \T         | the current time in 12-hour HH:MM:SS format                                                                                                                                         |
| \@         | the current time in 12-hour am/pm format                                                                                                                                            |
| \A         | the current time in 24-hour HH:MM format                                                                                                                                            |
| \u         | the username of the current user                                                                                                                                                    |
| \v         | the version of bash (e.g., 2.00)                                                                                                                                                    |
| \V         | the release of bash, version + patch level (e.g., 2.00.0)                                                                                                                           |
| \w         | the current working directory, with ${HOME} abbreviated with a tilde (uses the value of the PROMPT_DIRTRIM variable)                                                                |
| \W         | the basename of the current working directory, with ${HOME} abbreviated with a tilde                                                                                                |
| \!         | the history number of this command                                                                                                                                                  |
| \#         | the command number of this command                                                                                                                                                  |
| \$         | if the effective UID is 0, a #, otherwise a $                                                                                                                                       |
| \nnn       | the character corresponding to the octal number nnn                                                                                                                                 |
| \\         | a backslash                                                                                                                                                                         |
| \[         | begin a sequence of non-printing characters, which could be used to embed a terminal control sequence into the prompt                                                               |
| \]         | end a sequence of non-printing characters                                                                                                                                           |

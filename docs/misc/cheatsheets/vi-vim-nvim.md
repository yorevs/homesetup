# Vi/Vim/Neovim Cheatsheet

| Command       | Description                                 | Examples                                                                              |
|---------------|---------------------------------------------|---------------------------------------------------------------------------------------|
| :             | Enter command-line mode                     | Press `:` to enter command-line mode and input an ex command.                         |
| Esc           | Return to normal mode                       | Press `Esc` to exit insert or command mode.                                           |
| i             | Enter insert mode                           | Press `i` to begin inserting text at the cursor.                                      |
| o             | Open a new line below and enter insert mode | Press `o` to open a new line below the current line and switch to insert mode.        |
| :w            | Save current file                           | Type `:w` and press `Enter` to write changes.                                         |
| :q            | Quit Vim                                    | Type `:q` and press `Enter` to quit.                                                  |
| :wq           | Save and quit                               | Type `:wq` and press `Enter` to save and exit.                                        |
| :q!           | Quit without saving                         | Type `:q!` and press `Enter` to force-quit without saving.                            |
| ZZ            | Write file and quit                         | Press `ZZ` to save changes and exit Vim if the file is modified.                      |
| ZQ            | Quit without saving                         | Press `ZQ` to exit Vim without saving, regardless of modifications.                   |
| d             | Delete text (operator)                      | Press `d` followed by a motion (e.g., `dw` to delete a word, `dd` to delete a line).  |
| dd            | Delete current line                         | In normal mode, press `dd` to delete the current line.                                |
| yy            | Yank (copy) current line                    | In normal mode, press `yy` to copy the current line.                                  |
| p             | Paste after the cursor                      | In normal mode, press `p` to paste after the current line.                            |
| u             | Undo last change                            | In normal mode, press `u` to undo the previous action.                                |
| %             | Jump to matching bracket                    | Place the cursor on a bracket and press `%` to jump to its match.                     |
| gg            | Jump to the first line of file              | Press `gg` to move the cursor to the beginning of the file.                           |
| $             | Move to end-of-line (EOL)                   | Press `$` to jump to the end of the current line.                                     |
| 0             | Move to beginning-of-line (SOL)             | Press `0` to jump to the beginning of the current line.                               |
| G             | Jump to the last line of file               | Press `G` to move the cursor to the end of the file.                                  |
| Ctrl+r        | Redo last undone change                     | Press `Ctrl+r` to redo the change that was undone.                                    |
| /pattern      | Search forward for a pattern                | Type `/searchTerm` and press `Enter` to search forward.                               |
| ?pattern      | Search backward for a pattern               | Type `?searchTerm` and press `Enter` to search backward.                              |
| n             | Repeat search in the same direction         | Press `n` after a search to find the next occurrence.                                 |
| N             | Repeat search in the opposite direction     | Press `N` after a search to find the previous occurrence.                             |
| :%s/old/new/g | Replace all occurrences in the file         | Type `:%s/old/new/g` and press `Enter` to replace every instance of "old" with "new". |
| :set number   | Display line numbers                        | Type `:set number` to toggle line numbering on.                                       |
| :syntax on    | Enable syntax highlighting                  | Type `:syntax on` to enable syntax highlighting.                                      |
| :split        | Split window horizontally                   | Type `:split` or `:sp` to open a horizontal split.                                    |
| :vsplit       | Split window vertically                     | Type `:vsplit` or `:vsp` to open a vertical split.                                    |
| :tabnew       | Open a new tab (Vim/Neovim)                 | Type `:tabnew` to open a new tab page.                                                |
| :help         | Open help documentation                     | Type `:help` to access Vim's built-in help (e.g., `:help editing`).                   |
| :e <file>     | Open or edit a file                         | Type `:e filename` to open a file in the current session.                             |
| u             | Undo last change                            | Press `u` to undo the last modification.                                              |
| Ctrl-r        | Redo last undone change                     | Press `<C-r>` to redo the undone modification.                                        |
| yyp           | Duplicate current line                      | Press `yy` followed by `p` to duplicate the current line.                             |
| yy            | Copy (yank) current line                    | Press `yy` to copy the current line.                                                  |
| p             | Paste text after the cursor                 | Press `p` to paste the yanked text after the cursor.                                  |
| P             | Paste text before the cursor                | Press `P` to paste the yanked text before the cursor.                                 |

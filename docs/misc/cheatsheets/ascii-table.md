# Control Characters

```plaintxt
+-------------------------------------------------------------------------------------------------+
|                                       Control Characters                                        |
+------+------+-------+-------+-------------+-----------------------------------------------------+
| Char | Oct  | Dec   | Hex   | Control-Key | Control Action                                      |
+------+------+-------+-------+-------------+-----------------------------------------------------+
| NUL  | 0    | 0     | 0     | ^@          | Null character                                      |
| SOH  | 1    | 1     | 1     | ^A          | Start of heading, = console interrupt               |
| STX  | 2    | 2     | 2     | ^B          | Start of text, maintenance mode on HP console       |
| ETX  | 3    | 3     | 3     | ^C          | End of text                                         |
| EOT  | 4    | 4     | 4     | ^D          | End of transmission, not the same as ETB            |
| ENQ  | 5    | 5     | 5     | ^E          | Enquiry, goes with ACK; old HP flow control         |
| ACK  | 6    | 6     | 6     | ^F          | Acknowledge, clears ENQ logon hand                  |
| BEL  | 7    | 7     | 7     | ^G          | Bell, rings the bell...                             |
| BS   | 10   | 8     | 8     | ^H          | Backspace, works on HP terminals/computers          |
| HT   | 11   | 9     | 9     | ^I          | Horizontal tab, move to next tab stop               |
| LF   | 12   | 10    | a     | ^J          | Line Feed                                           |
| VT   | 13   | 11    | b     | ^K          | Vertical tab                                        |
| FF   | 14   | 12    | c     | ^L          | Form Feed, page eject                               |
| CR   | 15   | 13    | d     | ^M          | Carriage Return                                     |
| SO   | 16   | 14    | e     | ^N          | Shift Out, alternate character set                  |
| SI   | 17   | 15    | f     | ^O          | Shift In, resume default character set              |
| DLE  | 20   | 16    | 10    | ^P          | Data link escape                                    |
| DC1  | 21   | 17    | 11    | ^Q          | XON, with XOFF to pause listings; ":okay to send".  |
| DC2  | 22   | 18    | 12    | ^R          | Device control 2, block-mode flow control           |
| DC3  | 23   | 19    | 13    | ^S          | XOFF, with XON is TERM=18 flow control              |
| DC4  | 24   | 20    | 14    | ^T          | Device control 4                                    |
| NAK  | 25   | 21    | 15    | ^U          | Negative acknowledge                                |
| SYN  | 26   | 22    | 16    | ^V          | Synchronous idle                                    |
| ETB  | 27   | 23    | 17    | ^W          | End transmission block, not the same as EOT         |
| CAN  | 30   | 24    | 17    | ^X          | Cancel line, MPE echoes !!!                         |
| EM   | 31   | 25    | 19    | ^Y          | End of medium, Control-Y interrupt                  |
| SUB  | 32   | 26    | 1a    | ^Z          | Substitute                                          |
| ESC  | 33   | 27    | 1b    | ^[          | Escape, next character is not echoed                |
| FS   | 34   | 28    | 1c    | ^\          | File separator                                      |
| GS   | 35   | 29    | 1d    | ^]          | Group separator                                     |
| RS   | 36   | 30    | 1e    | ^^          | Record separator, block-mode terminator             |
| US   | 37   | 31    | 1f    | ^_          | Unit separator                                      |
```

# Printing Characters

```plaintxt
+-------------------------------------------------------------------------------------------------+
|                                     Printing Characters                                         |
+------+------+-------+-------+-------------+-----------------------------------------------------+
| Char | Oct  | Dec   | Hex   | Control-Key | Control Action                                      |
+------+------+-------+-------+-------------+-----------------------------------------------------+
| SP   | 40   | 32    | 20    |             | Space                                               |
| !    | 41   | 33    | 21    |             | Exclamation mark                                    |
| "    | 42   | 34    | 22    |             | Quotation mark (&quot; in HTML)                     |
| #    | 43   | 35    | 23    |             | Cross hatch (number sign)                           |
| $    | 44   | 36    | 24    |             | Dollar sign                                         |
| %    | 45   | 37    | 25    |             | Percent sign                                        |
| &    | 46   | 38    | 26    |             | Ampersand                                           |
| `    | 47   | 39    | 27    |             | Closing single quote (apostrophe)                   |
| (    | 50   | 40    | 28    |             | Opening parentheses                                 |
| )    | 51   | 41    | 29    |             | Closing parentheses                                 |
| *    | 52   | 42    | 2a    |             | Asterisk (star, multiply)                           |
| +    | 53   | 43    | 2b    |             | Plus                                                |
| ,    | 54   | 44    | 2c    |             | Comma                                               |
| -    | 55   | 45    | 2d    |             | Hyphen, dash, minus                                 |
| .    | 56   | 46    | 2e    |             | Period                                              |
| /    | 57   | 47    | 2f    |             | Slant (forward slash, divide)                       |
| 0    | 60   | 48    | 30    |             | Zero                                                |
| 1    | 61   | 49    | 31    |             | One                                                 |
| 2    | 62   | 50    | 32    |             | Two                                                 |
| 3    | 63   | 51    | 33    |             | Three                                               |
| 4    | 64   | 52    | 34    |             | Four                                                |
| 5    | 65   | 53    | 35    |             | Five                                                |
| 6    | 66   | 54    | 36    |             | Six                                                 |
| 7    | 67   | 55    | 37    |             | Seven                                               |
| 8    | 70   | 56    | 38    |             | Eight                                               |
| 9    | 71   | 57    | 39    |             | Nine                                                |
| :    | 72   | 58    | 3a    |             | Colon                                               |
| ;    | 73   | 59    | 3b    |             | Semicolon                                           |
| <    | 74   | 60    | 3c    |             | Less than sign (&lt; in HTML)                       |
| =    | 75   | 61    | 3d    |             | Equals sign                                         |
| >    | 76   | 62    | 3e    |             | Greater than sign (&gt; in HTML)                    |
| ?    | 77   | 63    | 3f    |             | Question mark                                       |
| @    | 100  | 64    | 40    |             | At-sign                                             |
| A    | 101  | 65    | 41    |             | Uppercase A                                         |
| B    | 102  | 66    | 42    |             | Uppercase B                                         |
| C    | 103  | 67    | 43    |             | Uppercase C                                         |
| D    | 104  | 68    | 44    |             | Uppercase D                                         |
| E    | 105  | 69    | 45    |             | Uppercase E                                         |
| F    | 106  | 70    | 46    |             | Uppercase F                                         |
| G    | 107  | 71    | 47    |             | Uppercase G                                         |
| H    | 110  | 72    | 48    |             | Uppercase H                                         |
| I    | 111  | 73    | 49    |             | Uppercase I                                         |
| J    | 112  | 74    | 4a    |             | Uppercase J                                         |
| K    | 113  | 75    | 4b    |             | Uppercase K                                         |
| L    | 114  | 76    | 4c    |             | Uppercase L                                         |
| M    | 115  | 77    | 4d    |             | Uppercase M                                         |
| N    | 116  | 78    | 4e    |             | Uppercase N                                         |
| O    | 117  | 79    | 4f    |             | Uppercase O                                         |
| P    | 120  | 80    | 50    |             | Uppercase P                                         |
| Q    | 121  | 81    | 51    |             | Uppercase Q                                         |
| R    | 122  | 82    | 52    |             | Uppercase R                                         |
| S    | 123  | 83    | 53    |             | Uppercase S                                         |
| T    | 124  | 84    | 54    |             | Uppercase T                                         |
| U    | 125  | 85    | 55    |             | Uppercase U                                         |
| V    | 126  | 86    | 56    |             | Uppercase V                                         |
| W    | 127  | 87    | 57    |             | Uppercase W                                         |
| X    | 130  | 88    | 58    |             | Uppercase X                                         |
| Y    | 131  | 89    | 59    |             | Uppercase Y                                         |
| Z    | 132  | 90    | 5a    |             | Uppercase Z                                         |
| [    | 133  | 91    | 5b    |             | Opening square bracket                              |
| \    | 134  | 92    | 5c    |             | Reverse slant (Backslash)                           |
| ]    | 135  | 93    | 5d    |             | Closing square bracket                              |
| ^    | 136  | 94    | 5e    |             | Caret (Circumflex)                                  |
| _    | 137  | 95    | 5f    |             | Underscore                                          |
| `    | 140  | 96    | 60    |             | Opening single quote                                |
| a    | 141  | 97    | 61    |             | Lowercase a                                         |
| b    | 142  | 98    | 62    |             | Lowercase b                                         |
| c    | 143  | 99    | 63    |             | Lowercase c                                         |
| d    | 144  | 100   | 64    |             | Lowercase d                                         |
| e    | 145  | 101   | 65    |             | Lowercase e                                         |
| f    | 146  | 102   | 66    |             | Lowercase f                                         |
| g    | 147  | 103   | 67    |             | Lowercase g                                         |
| h    | 150  | 104   | 68    |             | Lowercase h                                         |
| i    | 151  | 105   | 69    |             | Lowercase i                                         |
| j    | 152  | 106   | 6a    |             | Lowercase j                                         |
| k    | 153  | 107   | 6b    |             | Lowercase k                                         |
| l    | 154  | 108   | 6c    |             | Lowercase l                                         |
| m    | 155  | 109   | 6d    |             | Lowercase m                                         |
| n    | 156  | 110   | 6e    |             | Lowercase n                                         |
| o    | 157  | 111   | 6f    |             | Lowercase o                                         |
| p    | 160  | 112   | 70    |             | Lowercase p                                         |
| q    | 161  | 113   | 71    |             | Lowercase q                                         |
| r    | 162  | 114   | 72    |             | Lowercase r                                         |
| s    | 163  | 115   | 73    |             | Lowercase s                                         |
| t    | 164  | 116   | 74    |             | Lowercase t                                         |
| u    | 165  | 117   | 75    |             | Lowercase u                                         |
| v    | 166  | 118   | 76    |             | Lowercase v                                         |
| w    | 167  | 119   | 77    |             | Lowercase w                                         |
| x    | 170  | 120   | 78    |             | Lowercase x                                         |
| y    | 171  | 121   | 79    |             | Lowercase y                                         |
| z    | 172  | 122   | 7a    |             | Lowercase z                                         |
| {    | 173  | 123   | 7b    |             | Opening curly brace                                 |
| |    | 174  | 124   | 7c    |             | Vertical line                                       |
| }    | 175  | 125   | 7d    |             | Closing curly brace                                 |
| ~    | 176  | 126   | 7e    |             | Tilde (approximate)                                 |
| DEL  | 177  | 127   | 7f    |             | Delete (rubout), cross-hatch box                    |
```

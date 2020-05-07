"""
    @package: hhslib
    @script: colors.py
    @purpose: Common colors library
    @created: Mon 27, 2020
    @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
    @mailto: yorevs@hotmail.com
    @site: https://github.com/yorevs/homesetup
    @license: Please refer to <https://opensource.org/licenses/MIT>
"""


# @purpose: Terminal colors
from hhslib.commons import sysout


class Colors:
    def __init__(self):
        pass
    NC = '\x1b[0m'
    BLUE = '\x1b[0;34m'
    CYAN = '\x1b[0;36m'
    GREEN = '\x1b[0;32m'
    ORANGE = '\x1b[0;33m'
    RED = '\x1b[0;31m'
    YELLOW = '\x1b[0;33m'


# @purpose: Colored print
def cprint(color, message):
    sysout("{}{}{}".format(color, message, Colors.NC))



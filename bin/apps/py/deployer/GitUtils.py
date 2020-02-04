"""
  @package: deployer
   @script: GitUtils.py
  @purpose: Provides some git utilities.
  @created: Nov 14, 2019
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <http://unlicense.org/>
"""

from subprocess import check_output
from getpass import getuser


# @purpose: TODO Comment it
class Git:

    def __init__(self, command):
        self.command = 'project-dir'

    @staticmethod
    def top_level_dir():
        return check_output(['git', 'rev-parse', '--show-toplevel']).strip()

    @staticmethod
    def current_branch():
        return check_output(['git', 'symbolic-ref', '--short', 'HEAD']).strip()

    @staticmethod
    def user_name():
        return getuser()

    @staticmethod
    def changelog(from_tag, to_tag):
        return check_output(['git', 'log', '--oneline', '--pretty=format:%h %ad %s', '--date=short', "{}^..{}^".format(from_tag, to_tag)]).strip()

    @staticmethod
    def unreleased():
        latest_tag = check_output(['git', 'describe', "--tags", '--abbrev=0', 'HEAD^']).strip()
        return check_output(['git', 'log', '--oneline', '--pretty=format:%h %ad %s', '--date=short', "{}..HEAD".format(latest_tag)]).strip()

    @staticmethod
    def release_date(tag_name):
        return check_output(['git', 'log', '-1', '--format=%ad', '--date=short', tag_name]).strip()
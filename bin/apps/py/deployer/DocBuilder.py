"""
  @package: deployer
   @script: DocBuilder.py
  @purpose: Provides some document utilities.
  @created: Feb 06, 2020
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <http://unlicense.org/>
"""

import re


# @purpose: TODO Comment it
class Readme:

    def __init__(self):
        #self.file = '{}/README.md'.format(GitUtils.top_level_dir())
        self.file = '../samples/README.md'
        with open(self.file, 'r') as fh:
            regex = re.compile(r'(^%.*%$)')
            self.lines = fh.readlines()
            self.placeholders = map(lambda s: s.strip(), list(filter(regex.search, self.lines)))
            self.aliases = self.find_aliases()
            self.functions = self.find_functions()
            self.apps = self.find_apps()

    def __str__(self):
        return """
        File: 
            => {}
        Lines:
            => {}
        Placeholders:
            => {}
        Contents: 
            => {}
        """.format(self.file, len(self.lines), self.placeholders, self.contents())

    def contents(self):
        return self.lines

    def find_aliases(self):
        pass

    def find_functions(self):
        pass

    def find_apps(self):
        pass


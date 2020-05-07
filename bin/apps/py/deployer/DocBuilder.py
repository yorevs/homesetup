"""
  @package: deployer
   @script: DocBuilder.py
  @purpose: Provides some document utilities.
  @created: Feb 06, 2020
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <https://opensource.org/licenses/MIT>
"""

import re

from os import path, walk

from GitUtils import GitUtils


# @purpose: TODO Comment it
class Readme:

    def __init__(self):
        self.top_level_dir = GitUtils.top_level_dir()
        # self.file = '{}/README.md'.format(self.top_level_dir)
        self.file = '../sample-data/README.md'
        with open(self.file, 'r') as fh:
            regex = re.compile(r'(^%.*%$)')
            self.lines = fh.readlines()
            self.placeholders = map(lambda s: s.strip(), list(filter(regex.search, self.lines)))
            self.aliases = []
            self.functions = []
            self.apps = []
            self.find_aliases()
            self.find_functions()
            self.find_apps()

    def __str__(self):
        return """
        File: 
            => {}
        Lines:
            => {}
        Placeholders:
            => {}
        Aliases:
            => {}
        Functions:
            => {}
        Apps:
            => {}
        Contents: 
            => {}
        """.format(self.file, len(self.lines), self.placeholders, self.aliases, self.functions, self.apps,
                   self.contents())

    def contents(self):
        return self.lines

    def find_aliases(self):
        alias_path = '{}/dotfiles'.format(self.top_level_dir)
        for subdir, dirs, files in walk(alias_path):
            base_dir = path.basename(subdir)
            print("Found Dir => {}".format(base_dir))
            if not base_dir.startswith('.') and path.isdir(subdir):
                print("Digging into {}".format(subdir))
                for next_file in files:
                    print("Found file => {}".format(next_file))
                    file_info = path.splitext(next_file)
                    file_ext = file_info[1].lower()
                    if re.match("\\.(ba|z)sh", file_ext):
                        file_path = '{}/{}'.format(subdir, next_file)
                        with open(file_path, 'r') as fh:
                            print("Analyzing file {}".format(file_path))
                            regex = re.compile(r'^(alias|__hhs_alias)(.*)=\'(.*)\'$')
                            lines = fh.readlines()
                            self.aliases.extend(map(lambda s: s.strip(), list(filter(regex.search, lines))))

    def find_functions(self):
        functions_path = '{}/bin'.format(self.top_level_dir)
        for subdir, dirs, files in walk(functions_path):
            base_dir = path.basename(subdir)
            print("Found Dir => {}".format(base_dir))
            if not base_dir.startswith('.') and not base_dir == 'apps' and path.isdir(subdir):
                print("Digging into {}".format(subdir))
                for next_file in files:
                    print("Found file => {}".format(next_file))
                    file_info = path.splitext(next_file)
                    file_ext = file_info[1].lower()
                    if re.match("\\.(ba|z)sh", file_ext):
                        file_path = '{}/{}'.format(subdir, next_file)
                        with open(file_path, 'r') as fh:
                            print("Analyzing file {}".format(file_path))
                            regex = re.compile(r'^function (__hhs_.*)\(\) *{ *')
                            lines = fh.readlines()
                            funcs = map(lambda s: re.findall('__hhs_\\w*', s.strip()), list(filter(regex.search, lines)))
                            self.functions.extend([item for sublist in funcs for item in sublist])

    def find_apps(self):
        apps_path = '{}/bin/apps'.format(self.top_level_dir)
        for subdir, dirs, files in walk(apps_path):
            base_dir = path.basename(subdir)
            print("Found Dir => {}".format(base_dir))
            if not base_dir.startswith('.') and path.isdir(subdir):
                print("Digging into {}".format(subdir))
                for next_file in files:
                    print("Found file => {}".format(next_file))
                    file_info = path.splitext(next_file)
                    file_ext = file_info[1].lower()
                    if re.match("\\.((ba|z)sh|py)", file_ext):
                        file_path = '{}/{}'.format(subdir, next_file)
                        with open(file_path, 'r') as fh:
                            print("Analyzing file {}".format(file_path))
                            first_line = fh.readline()
                            if first_line.startswith("#!/usr/bin/env"):
                                self.apps.append(path.basename(file_path))

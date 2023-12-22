#!/usr/bin/env python

"""@script: prepare-commit-msg
  @purpose: Prevents a user to commit on master branch, unless unlocked.
  @created: Oct 30, 2019
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@gmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <https://opensource.org/licenses/MIT>
"""
import re
# Git provided parameters:
# $1 - the temporary file for the commit message
# $2 - the source of the commit message
# $3 - the commit SHA-1

import sys
from os import path, remove
from subprocess import check_output

# App arguments
branch_name = check_output(['git', 'symbolic-ref', '--short', 'HEAD']).strip()
top_level_dir = check_output(['git', 'rev-parse', '--show-toplevel']).strip()

# Master protection
master_unlock_file = 'master-unlock'
master_unlock_path = '%s/%s' % (top_level_dir, master_unlock_file)

# This will prevent any commit to master, unless, you are sure of it by creating a master unlock file
default_branch = str(check_output(["git", "symbolic-ref", "refs/remotes/origin/HEAD"]))
if re.search(r'^refs/remotes/origin/(.*)', default_branch):
    mat = re.search(r'^refs/remotes/origin/(.*)', default_branch)
    if branch_name == mat.group(1):
        if not path.exists(master_unlock_path):
            print("[ERROR] Can't commit to [MASTER]. Please use the a proper branch instead!")
            print("E.g: 'ISSUE-1230'")
            print("To create the branch type: ")
            print(" => $ git checkout -B ISSUE-1230")
            print("If you really want to commit to master create the unlock file: ")
            print(" $ touch {}".format(master_unlock_file))
            print("And commit again !")
            sys.exit(1)
        else:
            print('[WARN] Commit to master unlocked ONCE. Create another {} file to commit to master again'
                  .format(master_unlock_path))
            try:
                remove(master_unlock_path)
                open(master_unlock_path, 'a').close()
            except OSError as error:
                print('[ERROR] Unable to remove master unlock file: {}. Commit to master aborted!'
                      .format(master_unlock_path))
                sys.exit(1)

sys.exit(0)

#!/usr/bin/env python

"""@script: commit-msg
  @purpose: Prepares a git commit message to conform with the message format rules
  @created: Oct 30, 2019
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@gmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <https://opensource.org/licenses/MIT>
"""

# Git provided parameters:
# $1 - the temporary file for the commit message

import getpass
import os.path
import re
import sys
from os import path, remove
from subprocess import check_output

commit_msg_file = sys.argv[1] if len(sys.argv) > 1 else None

if not commit_msg_file or not os.path.exists(commit_msg_file):
    print('Message file "{}" does not exist'.format(commit_msg_file))
    sys.exit(1)

# App arguments
user_name = getpass.getuser()
branch_name = check_output(['git', 'symbolic-ref', '--short', 'HEAD'])
branch_name = str(branch_name).strip()
top_level_dir = str(check_output(['git', 'rev-parse', '--show-toplevel'])).strip()
master_unlock = top_level_dir + '/master-unlock'

commit_msg = None

# CARDS
card_prefix = '[a-zA-Z][a-zA-Z0-9\\-_]+'
card_format = '%s - [%s-%s:{@%s}]'  # Msg/Card/Number/User
card_regex = '(' + card_prefix + ')-(\\d+)'

# NOT CARDS
changelog = '^(([Mm]erge|[Aa]dded|[Cc]hanged|[Dd]eprecated|[Rr]emoved|[Ff]ixed|[Ss]ecurity){1}).+'
no_card_prefix = 'test|hotfix|feature|develop'
no_card_format = '%s - [%s:{@%s}]'  # Msg/Issue/User
no_card_regex = '(' + no_card_prefix + ')(-(\\w+(-\\d+)*))?'

# Matching CARD branches
if re.match(card_regex, branch_name):
    mat = re.match(card_regex, branch_name)
    card_name = mat.group(1).upper()
    card_number = mat.group(2)
    commit_msg_format = '.*- \\[%s-%s\\:\\{\\@%s\\}\\]' % (card_name, card_number, user_name)
    with open(commit_msg_file, 'r+') as fh:
        commit_msg = fh.read().strip()
        # Check if the commit message already matches the expected format
        if not re.match(commit_msg_format, commit_msg):
            formatted_msg = card_format % (commit_msg, card_name, card_number, user_name)
            fh.seek(0, 0)
            fh.write(formatted_msg)

# Matching non-CARD branches
elif re.match(no_card_regex, branch_name):
    mat = re.match(no_card_regex, branch_name)
    branch = mat.group(1).upper()
    commit_msg_format = '.* - \\[%s\\:\\{\\@%s\\}\\]' % (branch, user_name)
    with open(commit_msg_file, 'r+') as fh:
        commit_msg = fh.read().strip()
        if re.match(changelog, commit_msg):
            # Check if the commit message already matches the expected format
            if not re.match(commit_msg_format, commit_msg):
                formatted_msg = no_card_format % (commit_msg, branch, user_name)
                fh.seek(0, 0)
                fh.write(formatted_msg)
        else:
            print('Your message does not comply with any changelog type {}. Commit aborted !'
                  .format(changelog))
            sys.exit(1)

# Rejecting unknown branch names
else:
    if "master" == branch_name:
        if not path.exists(master_unlock):
            print(sys.argv)
            print('Master not unlocked: {}. Commit aborted !'.format(master_unlock))
            sys.exit(1)
        else:
            remove(master_unlock)
    else:
        print('Incorrect branch name: {}'.format(branch_name))

sys.exit(0)

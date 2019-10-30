#!/usr/bin/env python

"""@package -
   @script: prepare-commit-msg
  @purpose: Prepares a git commit message to conform with the message format rules
  @created: Oct 30, 2019
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@gmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <http://unlicense.org/>
"""

# Git provided parameters:
# $1 - the temporary file for the commit message
# $2 - the source of the commit message
# $3 - the commit SHA-1

import sys, re, getpass
from subprocess import check_output

commit_msg_filepath = sys.argv[1]
commit_msg = None

card_prefix = '.*'
no_card_prefix = 'test|hotfix|feature'

branch_name = check_output(['git', 'symbolic-ref', '--short', 'HEAD']).strip()
user_name = getpass.getuser()

re_no_card = '(' + no_card_prefix + ')-(\w+(-\d+)*)'
re_card = '(' + card_prefix + ')-(\d+)'

if branch_name == 'master':
    print 'Can\'t commit to master. Please use the proper branch: git checkout -B <branch_name>'
    sys.exit(1)

if re.match(re_no_card, branch_name):
    mat = re.match(re_no_card, branch_name)
    issue = mat.group(1)
    with open(commit_msg_filepath, 'r+') as fh:
        commit_msg = fh.read().strip()
        fh.seek(0, 0)
        fh.write('[%s:{@%s}] - %s' % (issue.upper(), user_name, commit_msg))
elif re.match(re_card, branch_name):
    mat = re.match(re_card, branch_name)
    card_name = mat.group(1)
    card_number = mat.group(2)
    with open(commit_msg_filepath, 'r+') as fh:
        commit_msg = fh.read().strip()
        fh.seek(0, 0)
        fh.write('[%s-%s:{@%s}] - %s' % (card_name.upper(), card_number, user_name, commit_msg))
else:
    print 'Incorrect branch name: %s' % branch_name
    sys.exit(1)

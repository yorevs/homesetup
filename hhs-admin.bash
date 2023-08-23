#!/usr/bin/env bash

# Add the HomeSetup group
# TODO Check is the group does not exist before adding it
groupadd homesetup

# Clone the repository
# TODO Check is the repo does not exist before cloning it, pull otherwise
git clone https://github.com/yorevs/homesetup.git /var/lib/homesetup

# Change the group of HomeSetup files to homesetup
chgrp -R homesetup /var/lib/homesetup

# Give read permissions to homesetup group
chmod g+r -R /var/lib/homesetup

# Add users to the homesetup group
usermod -a -G homesetup jenkins

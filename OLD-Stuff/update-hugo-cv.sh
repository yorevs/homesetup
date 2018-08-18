#!/bin/bash

################################################################################
# C-Shell: update-hugo-cv.sh
# Purpose: Update the Curriculum Vitae to Sites dir.
# Autor: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
# Mailto: hugos@inatel.br
# Data: Jul, 16th 2013
################################################################################

HOME=${HOME:-~/}

CV_HOME="$HOME/Dropbox/Eclipse_Works/WebProjects/CurriculumVitae"

DEPLOY_DIR="$HOME/Sites/CV"

PROG_NAME=$(basename $0 | cut -d "." -f 1)

echo "[$PROG_NAME] Configuring Curriculum Vitae "

echo "[$PROG_NAME] Removing old site"
test -f "$DEPLOY_DIR/cv-Hugo-ptBR.html" && rm -rf $DEPLOY_DIR

test -d $DEPLOY_DIR || mkdir -p $DEPLOY_DIR

cp -r $CV_HOME/* $DEPLOY_DIR

echo "[$PROG_NAME] Curriculum deployed at: $DEPLOY_DIR"
echo "[$PROG_NAME] Done."
echo ' '
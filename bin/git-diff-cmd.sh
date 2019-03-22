#!/usr/bin/env bash

DIFFTOOL=${DIFFTOOL:-git diff --no-index --color}

xattr -w com.apple.TextEncoding "UTF-8;134217984" "$2"
xattr -w com.apple.TextEncoding "UTF-8;134217984" "$5"

${DIFFTOOL} "$2" "$5"
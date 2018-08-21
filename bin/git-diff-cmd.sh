#!/usr/bin/env bash

xattr -w com.apple.TextEncoding "UTF-8;134217984" "$2"
xattr -w com.apple.TextEncoding "UTF-8;134217984" "$5"

opendiff "$2" "$5" -merge "$1"
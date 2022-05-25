#!/bin/bash

# usage: i7x Emily\ Short/Computers.i7x

EXT="$@"
I7EXTERNAL="$HOME/github/i7/External"
I7INTERNAL="$HOME/github/i7/inform/inform7/Internal"
I7TRANSIENT="$HOME/github/i7/Transient"

intest inform7 -using -extension "$EXT" -do -catalogue |
  perl -ne '/Example\s+(.+)\s+=/ && print "$1\n"' |
  while read letter; do
    INF="$letter.i7"
    I6="$letter.i6"
    ULX="$letter.ulx"
    intest inform7 -using -extension "$EXT" -do -source "$letter" -to "$INF"
    inform7 -no-census-update -transient "$I7TRANSIENT" -external "$I7EXTERNAL" -internal "$I7INTERNAL" -no-progress -o "$I6" -source "$INF"
    inform6 -E2SDwG "$I6" "$ULX"
    [[ "Z`intest inform7 -using -extension "$EXT" -do -script "$letter"`" != "Z" ]] && echo 'test me' | cheap-glulxe "$ULX"
  done

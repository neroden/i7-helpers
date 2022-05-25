#!/bin/bash

# usage: i7x Emily\ Short/Computers.i7x

EXT="$@"
I7EXTERNAL="$HOME/github/i7/External"
I7TRANSIENT="$HOME/github/i7/Transient"

intest inform7 -using -extension "$EXT" -do -catalogue |
  perl -ne '/Example\s+(.+)\s+=/ && print "$1\n"' |
  while read letter; do
    INF="$letter.i7"
    I6="$letter.i6"
    ULX="$letter.ulx"
    intest inform7 -using -extension "$EXT" -do -source "$letter" -to "$INF"
    inform7 -no-census-update -transient "$I7TRANSIENT" -external "$I7EXTERNAL" -no-census-update -no-progress -o "$I6" -source "$INF"
    inform6 -E2SDwG "$I6" "$ULX"
    echo "$ULX"
    if [[ -e "$ULX" ]]; then
        echo "exists"
        fi
        
    if [[ "Z`intest inform7 -using -extension "$EXT" -do -script "$letter"`" != "Z" ]]; then
      echo 'test me' | cheap-glulxe "$ULX"
    fi
  done

#!/bin/bash

# usage: i7x "Emily Short/Computers.i7x"

# Locations of Inform tools: user will probably need to change these
I7_BUILD_PATH="${HOME}/programming/inform-build"
INWEB="${I7_BUILD_PATH}/inweb/Tangled/inweb"
INTEST="${I7_BUILD_PATH}/intest/Tangled/intest"
INFORM7="${I7_BUILD_PATH}/inform/inform7/Tangled/inform7"
INFORM6="${I7_BUILD_PATH}/inform/inform6/Tangled/inform6"

# Inform's working directories: user will probably need to change these
# Directory which has your Extensions directory in it
I7EXTERNAL="${HOME}/Inform"
# I7EXTERNAL="$I7PATH/usr/local/share/inform7-ide/External"

# Directory containing internal Extensions and Kits
I7INTERNAL="${I7_BUILD_PATH}/inform/inform7/Internal"
# I7INTERNAL="$I7PATH/usr/local/share/inform7-ide/External"

# Working directory for I7 extension catalog etc.
I7TRANSIENT="$HOME/Inform"
# I7TRANSIENT="$HOME/github/i7/Transient"

# Find Glulxe.  User may need to change this.
GLULXE="usr/games/glulxe"
# GLULXE="/usr/local/bin/cheap-glulxe"

# Below this should not need user changes

# Get a temporary directory for us
my_tmpdir=$( mktemp -d -t i7x-XXXXXXXX )

# intest wants a directory as a first argument, but our calls to intest don't use it
INTEST_DIR="notrealdir"

# Extension passed at the command line; construct full path
EXT="$@"
EXT_FULLPATH="${I7EXTERNAL}/Extensions/${EXT}"

# Note that the first argument to intest is an unused directory
"${INTEST}" "${INTEST_DIR}" -using -extension "${EXT_FULLPATH}" -do -catalogue 1> "${my_tmpdir}/catalogue"
# Print the catalog to the user for clarity
cat "${my_tmpdir}/catalogue"

# Now for the very confusing pipeline
cat "${my_tmpdir}/catalogue" |
  perl -ne '/Example\s+(.+)\s+=/ && print "$1\n"' |
  while read letter; do
    INF="${my_tmpdir}/${letter}.i7"
    I6="${my_tmpdir}/{letter}.i6"
    ULX="${my_tmpdir}/{letter}.ulx"
    "${INTEST}" ${INTEST_DIR} -using -extension "${EXT_FULLPATH}" -do -source "$letter" -to "$INF"
    "${INFORM7}" -silence -no-census-update -transient "${I7TRANSIENT}" -external "${I7EXTERNAL}" -internal "${I7INTERNAL}" -no-progress -o "$I6" -source "$INF"
    "${INFORM6}" -E2SDwG '$OMIT_UNUSED_ROUTINES=1' "$I6" "$ULX"
    if [[ "Z`${INTEST} ${INTEST_DIR} -using -extension "${EXT_FULLPATH}" -do -script "${letter}"`" != "Z" ]]; then
      echo -n "Example $letter: ";
      head -1 "$INF"
      echo 'test me' | "$GLULXE" "$ULX"
    fi
  done

# Clean up temporary directory
rm -r "${my_tmpdir}"

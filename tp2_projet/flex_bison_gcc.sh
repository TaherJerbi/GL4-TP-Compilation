#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Please provide a name as an argument"
  exit 1
fi

name=$1

bison -d "${name}.y"
flex -o "${name}.yy.c" "${name}.lex"
gcc -o "${name}" "${name}.tab.c" "${name}.yy.c"
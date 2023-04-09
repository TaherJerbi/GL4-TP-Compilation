#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Please provide a name as an argument"
  exit 1
fi

name=$1

flex -o "${name}.yy.c" "${name}.lex"
gcc -o "${name}" "${name}.yy.c"
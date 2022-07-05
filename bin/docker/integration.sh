#!/bin/bash
set -e

dpkg-reconfigure -f noninteractive tzdata
npm install moment --save

if (($#)); then
  echo 'Running integration tests for single file'
  cp $1 blueprint/temp.apib
  dredd blueprint/temp.apib http://rails:3000/ --sorted --hookfiles=./hooks*.js
  rm blueprint/temp.apib
  exit 0
fi

echo 'Merging test files'
(for each in blueprint/*.md; do cat $each; echo ""; done) > apiary.apib

echo 'Running integration tests'
dredd apiary.apib http://rails:3000/ --sorted --hookfiles=./hooks*.js

RESULT=$?
exit $RESULT

#!/bin/sh

# Path to pdx info to be updated
FILE=./source/pdxinfo

# Path to folder for pdxinfo backup. Also add this folder to you .gitignore file
BAK=./tmp

echo "> Backing up pdxinfo\n"
cp $FILE $BAK

echo "> BACKED UP:"
cat $BAK/pdxinfo
echo "\n"

BUILD=$(cat $FILE | grep buildNumber | tr -dc '0-9')
echo "> CURRENT BUILD: $BUILD"

BUILD=$((BUILD+1))
echo "> NEW BUILD: $BUILD"

echo "> WRITING NEW BUILD NUMBER: $BUILD"
# Make sure you already have a buildNumber=0 (or any number) in your pdxinfo
sed -i '' "s/buildNumber=[0-9]*/buildNumber=$BUILD/g" $FILE
echo "\n"

echo "> UPDATED pdxinfo:"
cat $FILE
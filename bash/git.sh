#!/bin/bash

operation=$1


folder="../README.md ../bash/*sh ../gmt/*sh ../octave/*m ../figures/*svg ../figures/*pdf" 
#folder="../README.md"

#folder=$2

if [ $operation == 'push' ]
then
  git add $folder
  git commit -m "pushing to Github"
  git push origin master
elif [ $operation == 'pull' ]
then
  git commit -m "pulling from Github"
  git pull origin master
fi

#!/bin/bash
if ! type "curl" > /dev/null 2>&1
then
  echo "Require CURL Command"
else
 if [ "$(id -u)" != "0" -a "$(whoami)" != "cocktail" ]; then
  echo "root or cocktail user only script"
 else
  if [ $# -ne 2 ]; then
   echo "require [user],[repo]"
  else
   COCKTAIL=/home/cocktail
   BAR=/bar
   DIR=$2-master
   DOWNLOAD=$DIR.tar.gz
   echo -n "Repository:github.com/$1/$2 ? [y]: "
   read ans
   case $ans in
    '' | y* | Y* )
      if [ "$(id -u)" == "0" ]; then
       mkdir -p $BAR
        chmod 777 $BAR
       if [ ! -L $COCKTAIL ]; then
        ln -s $BAR $COCKTAIL
       fi
      fi
      chmod 777 $COCKTAIL
      cd $COCKTAIL
      curl -L "https://github.com/$1/$2/archive/master.tar.gz" -o $DOWNLOAD
      tar -xvf $DOWNLOAD
      rm -f $DOWNLOAD
      mv $DIR $2
      echo complete
      DIR=$(cd $(dirname ${BASH_SOURCE}); pwd)
      FILE=${BASH_SOURCE##*/}
      rm -f "${DIR%/}/${FILE}"
     ;;
    * )
     ;;
   esac
  fi
 fi
fi

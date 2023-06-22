#! /bin/sh

if [[ $# -eq 0 ]]; then
    echo "Usage: update.sh <formula> <new version>"
    exit 1
fi

if [[ -e Formula/$1.rb ]]; then
  url=$(grep url Formula/$1.rb | cut -d '"' -f 2)
  url=$(sed "s!\#{VERSION}!$2!g" <<< $url)
  curl -LO $url
  if [[ -e ${url##*/} ]]; then
    sha256=$(shasum -a 256 ${url##*/} | cut -d ' ' -f 1)
    sed -i '' "s/sha256 .*/sha256 \"$sha256\"/"  Formula/$1.rb
    sed -i '' "s/VERSION=\".*\"/VERSION=\"$2\"/" Formula/$1.rb
    rm ${url##*/}
    echo "$1 version $2: updated"
  else
    echo "$1 version $2: no distribution file found"
    exit 2
  fi
else 
    echo "$1: no formulae found"
fi


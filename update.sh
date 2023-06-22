#! /bin/sh

if [[ $# -lt 2 ]]; then
    echo "Usage: update.sh <formula> <new version>"
    exit 1
fi

__perform_update() {
  if [[ -e Formula/$1.rb ]]; then
    url=$(grep url Formula/$1.rb | cut -d '"' -f 2)
    url=$(sed "s!\#{VERSION}!$2!g" <<< $url)
    curl --fail -LO $url
    if [[ $? -ne 0 ]]; then
      echo "$1 version $2: download failed"
      exit 2
    fi
    if [[ -e ${url##*/} ]]; then
      sha256=$(shasum -a 256 ${url##*/} | cut -d ' ' -f 1)
      sed -e "s/sha256 .*/sha256 \"$sha256\"/" \
          -e "s/VERSION=\".*\"/VERSION=\"$2\"/" Formula/$1.rb > Formula/$1.rb.tmp
      mv Formula/$1.rb.tmp Formula/$1.rb
      rm ${url##*/}
      echo "$1 version $2: updated"
    else
      echo "$1 version $2: no distribution file found"
      exit 3
    fi
  else 
      echo "$1: no formulae found"
  fi
  return 0
}

__update_readme() {
    awk -F '|' -v TARGET=$1 -v VERSION=$2 -v DATE=$(date +%Y-%m-%d) -f bin/readme_updater.awk README.md > README.tmp
    mv README.tmp README.md
    echo "$1 version $2: updated in README.md"
    return 0
}

__perform_update $1 $2
if [[ $? -eq 0 ]]; then
  __update_readme $1 $2
fi
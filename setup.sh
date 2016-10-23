#! /bin/sh

function install_gem {
  gem install $1
}

function check_gem {
  gem=$1

  if gem list | grep --quiet $gem; then
    echo "Found $gem"
  else
    echo "Did not find gem $gem"
    install_gem $gem
  fi
}

check_gem "sass"
check_gem "bourbon"
check_gem "neat"


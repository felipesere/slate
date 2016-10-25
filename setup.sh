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

function check_brew {
  if brew info $1 &> /dev/null; then
    echo "Found $1 installed from brew"
  else
    brew install erlang
  fi
}

function check_erlang {
  erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().'  -noshell
}

# should check for Erlang 19
check_brew "erlang"
check_erlang "19"
# should check for Elixir
# should update deps

check_gem "sass"
check_gem "bourbon"
check_gem "neat"

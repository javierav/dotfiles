# vim: ft=sh

# Overwrite bash commands
alias ls="command ls -h --color"
alias mkdir="mkdir -pv"
alias ..="cd .."

# Utilities
alias server='ruby -run -e httpd . -p 1234' # Ruby using HTTPD
alias myip="curl http://ipecho.net/plain; echo"

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

# Bundler
alias bi="bundle install -j$(nproc)"

# Rails
alias rs="bundle exec rails s -b 0.0.0.0"
alias rc="bundle exec rails c"

# Include custom aliases
[[ -s "$HOME/.bash_aliases.local" ]] && source "$HOME/.bash_aliases.local"

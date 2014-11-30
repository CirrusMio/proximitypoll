# Return an error
_proximity_error() {
  echo -e ">>> ERROR: $*" >&2
  exit 1
}

# Return a token
_proximity_token() {
  url="$(_door_fetch "url")"
  curl -G "${url}/token"
}

# Generate proximity notification
_proximity_poller() {
  token="$(__proximity_fetch "token")"
  [ ! "$token" ] && _proximity_error "Please set your token in your .proximity file."
  words="$(echo "$@" | sed 's/ /\+/g')"
  curl -sG --data-urlencode "token=$token" \
           --data-urlencode "words=$words" "${url}/proximitypoll"
#	^^^^May need significant rework
}

# Print out usage info
_proximity_usage() {
  cat << EOF
Usage: door action
actions:
    token - fetch a token
    ? - ?
    h - print usage
EOF
}

# Fetch a value from the config file
_proximity_fetch() {
  key="$1"; shift
  awk -F ': ' "/${key}/ { print \$2 }" "$proximity_config"
}

# Exit if there is no configuration file
proximity_config="$HOME/.door"
[ ! "$proximity_config" ]  && _proximity_error "Configuration file not found."

action="$1"
case "$action" in
  token) _proximity_token;;
  say) _proximity_say;;
  h) _proximity_usage;;
  *) _proximity_usage;;
esac

exit 0
#!/usr/bin/env bash

# JSON parsing stolen from https://github.com/dominictarr/JSON.sh

throw() {
  echo "$*" >&2
  exit 1
}

awk_egrep() {
  local pattern_string=$1

  gawk '{
    while ($0) {
      start=match($0, pattern);
      token=substr($0, start, RLENGTH);
      print token;
      $0=substr($0, start+RLENGTH);
    }
  }' pattern="$pattern_string"
}

json_tokenize() {
  local GREP
  local ESCAPE
  local CHAR

  if echo "test string" | egrep -ao --color=never "test" >/dev/null 2>&1; then
    GREP='egrep -ao --color=never'
  else
    GREP='egrep -ao'
  fi

  if echo "test string" | egrep -o "test" >/dev/null 2>&1; then
    ESCAPE='(\\[^u[:cntrl:]]|\\u[0-9a-fA-F]{4})'
    CHAR='[^[:cntrl:]"\\]'
  else
    GREP=awk_egrep
    ESCAPE='(\\\\[^u[:cntrl:]]|\\u[0-9a-fA-F]{4})'
    CHAR='[^[:cntrl:]"\\\\]'
  fi

  local STRING="\"$CHAR*($ESCAPE$CHAR*)*\""
  local NUMBER='-?(0|[1-9][0-9]*)([.][0-9]*)?([eE][+-]?[0-9]*)?'
  local KEYWORD='null|false|true'
  local SPACE='[[:space:]]+'

  # Force zsh to expand $A into multiple words
  local is_wordsplit_disabled=$(unsetopt 2>/dev/null | grep -c '^shwordsplit$')
  if [ $is_wordsplit_disabled != 0 ]; then setopt shwordsplit; fi
  $GREP "$STRING|$NUMBER|$KEYWORD|$SPACE|." | egrep -v "^$SPACE$"
  if [ $is_wordsplit_disabled != 0 ]; then unsetopt shwordsplit; fi
}

json_parse_array() {
  local index=0
  local ary=''

  read -r token
  case "$token" in
    ']') ;;
    *)
      while :; do
        json_parse_value "$1" "$index"
        index=$((index + 1))
        ary="$ary""$value"

        read -r token
        case "$token" in
          ']') break ;;
          ',') ary="$ary," ;;
          *) fail "EXPECTED , or ] GOT ${token:-EOF}" ;;
        esac

        read -r token
      done
      ;;
  esac

  value=$(printf '[%s]' "$ary")
}

json_parse_object() {
  local key
  local obj=''

  read -r token
  case "$token" in
    '}') ;;
    *)
      while :; do
        case "$token" in
          '"'*'"') key=$token ;;
          *) fail "EXPECTED string GOT ${token:-EOF}" ;;
        esac

        read -r token
        case "$token" in
          ':') ;;
          *) fail "EXPECTED : GOT ${token:-EOF}" ;;
        esac

        read -r token
        json_parse_value "$1" "$key"
        obj="$obj$key:$value"

        read -r token
        case "$token" in
          '}') break ;;
          ',') obj="$obj," ;;
          *) fail "EXPECTED , or } GOT ${token:-EOF}" ;;
        esac

        read -r token
      done
      ;;
  esac

  value=$(printf '{%s}' "$obj")
  :
}

json_parse_value() {
  local jpath="${1:+$1,}$2"

  case "$token" in
    '{') json_parse_object "$jpath" ;;
    '[') json_parse_array "$jpath" ;;
      # At this point, the only valid single-character tokens are digits.
    '' | [!0-9]) fail "EXPECTED value GOT ${token:-EOF}" ;;
    # value with solidus ("\/") replaced in json strings with normalized value: "/"
    *) value=$(echo "$token" | sed 's#\\/##g') ;;
  esac

  [ "$value" = '' ] && return
  printf "[%s]\t%s\n" "$jpath" "$value"
  :
}

json_parse() {
  json="$1"

  [ -z "$json" ] && return

  echo "$json" | json_tokenize | (
    read -r token
    json_parse_value
    read -r token
  )

  case "$token" in
    '') ;;
    *) fail "EXPECTED EOF GOT $token" ;;
  esac
}

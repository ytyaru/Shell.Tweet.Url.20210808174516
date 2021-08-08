#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# TweetするURLを生成するスクリプトを書く。
# CreatedAt: 2021-08-08
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	cd "$HERE"
	local VERSION=0.0.1
	local PATH_TXT_HELP="$HERE/help.txt"
	local URL=; local HASH_TAGS=; local TEXT=;
	IsExistCmd() { type "$1" >/dev/null 2>&1; }
	Install() { sudo apt install -y $1; }
	GetArgs() {
		Help() { eval "cat <<< \"$(cat "$PATH_TXT_HELP")\""; exit 1; }
		while getopts u:t:h OPT; do
		case $OPT in
			u) URL=$OPTARG;;
			t) HASH_TAGS=$OPTARG;;
			h|\?) Help; exit 0;;
		esac
		done
		shift $((OPTIND - 1))
		[ 0 -eq $# ] && { Help; exit 1; }
#		TEXT="$1";
		TEXT="$(eval echo -e "$1")";
	}
#	UrlEncode() { echo "$1" | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n'; }
#	UrlEncode() { echo "$1" | nkf -WwMQ | sed 's/=$//g' | tr = % | tr '\n' '%0A'; }
	UrlEncode() { python -c 'import sys, urllib; print urllib.quote(sys.stdin.read()),'; }
	UrlDecode() { python -c 'import sys, urllib; print urllib.unquote_plus(sys.stdin.read()),'; }
	MakeTweetUrl() {
		local BASE_URL=https://twitter.com/intent/tweet
		local P_TEXT="text=$(echo -e "$TEXT" | UrlEncode)"
		local P_HASH_TAGS="hashtags=$(echo -e "$HASH_TAGS" | UrlEncode)"
		local P_URL="url=$(echo -e "\n$URL" | UrlEncode)"
		local TWEET_URL="${BASE_URL}?${P_TEXT}"
		[ -n "$HASH_TAGS" ] && TWEET_URL+="&${P_HASH_TAGS}"
		[ -n "$URL" ] && TWEET_URL+="&${P_URL}"
		echo "$TWEET_URL"
	}
#	IsExistCmd nkf || Install nkf
	IsExistCmd python || Install python
	GetArgs "$@"
	MakeTweetUrl
}
Run "$@"

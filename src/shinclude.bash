#!/bin/bash

typeset -A BLOCK_PASS
typeset -a SHINCLUDE_PATH
SHINCLUDE_PATH=()
SHINCLUDE_PATH+=("$PWD")

#-----------------------------------
# BEGIN-INCLUDE src/logging.bash
# END-INCLUDE
# BEGIN-INCLUDE src/style.bash
# END-INCLUDE
# BEGIN-INCLUDE src/block-EVAL.bash
# END-INCLUDE
# BEGIN-INCLUDE src/block-INCLUDE.bash
# END-INCLUDE
# BEGIN-INCLUDE src/block-RENDER.bash
# END-INCLUDE
# BEGIN-INCLUDE src/block-MARKDOWN-TOC.bash
# END-INCLUDE
#-----------------------------------

# ### usage
#
# Show usage
#
usage() {
  echo "Usage: $0 [-h] [-c COMMENT_STYLE] [-i] <action> [input-file]"
  [[ ! -z "$1" ]] && echo -e "\n!! $* !!\n"
  echo '
  Input File:

    If input-file is "-", read from STDIN.
    If no input-file is given, assume "./README.md"'
}

# shellcheck disable=2094
_parse_lines() {
    local pass line begin end blocktype blockargs block infile
    pass=$1
    infile=$2
    IFS=$'\n'
    while read -r line;do
      if [[ "$line" = "$COMMENT_START BEGIN-"* ]];then
          begin="$line"

          blocktype="${begin:${#COMMENT_START}:${#line}}"
          blocktype="${blocktype##*BEGIN-}"
          blocktype="${blocktype%$COMMENT_END}"
          blocktype="${blocktype%% *}"

          blockargs="${begin:${#COMMENT_START}:${#line}}"
          blockargs="${blockargs#*BEGIN-$blocktype}"
          blockargs="${blockargs# }"
          blockargs="${blockargs% $COMMENT_END}"

          block=""
          while
              read -r line \
              && [[ "$line" != "$COMMENT_START END-$blocktype"* \
              && "$line" != *"END-$blocktype $COMMENT_END"   ]]
          do
              printf -v block "%s\n%s" "$block" "$line"
          done
          if ! declare -f -F "_block_$blocktype">/dev/null;then
              _error "No such block type '$blocktype'"
          fi
          if [[ ${BLOCK_PASS[$blocktype]} != $pass ]];then
              _debug 1 "PASS $pass: SKIP '$blocktype' '$blockargs'"
              printf "%s\n%s\n%s\n" "$begin" "$block" "$line"
              continue;
          fi
          _debug 1 "PASS $pass: RUN $blocktype '$blockargs'"
          _debug 2 "PASS $pass: RUN $blocktype '$blockargs' '$block'"
          printf "%s\n%s\n\n%s\n" \
              "$begin" \
              "$("_block_$blocktype" "$blockargs" "$block" "$infile")" \
              "$line"
      else
          _debug 2 "PASS $pass: (ign) $line"
          printf "%s\n" "$line"
      fi
    done < "$infile"
}

## ## OPTIONS
_parse_args() {

    while [[ "$1" != '-' && "$1" = -* ]];do
        case "$1" in
            -h)
                ## ### -h
                ## ### --help
                ##
                ## help
                ##
                usage
                exit ;;
            -i|--inplace)
                ## ### -i
                ## ### --inplace
                ##
                ## Edit the file in-place
                ##
                IN_PLACE=true 
                ;;
            -p|--shinclude-path)
                ## ### -p PATH
                ## ### --shinclude-path PATH
                ##
                ## Add path to path to look for `INCLUDE` and `RENDER`.
                ##
                ## Can be repeated to add multiple paths.
                ##
                ## Default: `("$PWD")`
                ##
                SHINCLUDE_PATH+=("$2"); shift
                ;;
            -c|--coment-style)
                ## ### -c COMMENT_STYLE
                ## ### --comment-style COMMENT_STYLE
                ##
                ## Comment style. See [COMMENT STYLES](#comment-styles).
                ##
                COMMENT_STYLE="$2"; shift
                ;;
            -cs|--comment-start)
                ## ### -cs COMMENT_START
                ## ### --comment-start COMMENT_START
                ##
                ## Comment start. Overrides language-specific comment start.
                ##
                ## See [COMMENT STYLES](#comment-styles).
                ##
                COMMENT_START="$2"; shift
                ;;
            -ce|--comment-end)
                ## ### -ce COMMENT_END
                ## ### --comment-end COMMENT_END
                ##
                ## Comment end. Overrides language-specific comment end.
                ##
                ## See [COMMENT STYLES](#comment-styles).
                ##
                COMMENT_END="$2"; shift
                ;;
            -d|--info)
                ## ### -d
                ## ### --info
                ##
                ## Enable debug logging ([`$LOGLEVEL=1`](#loglevel))
                ##
                # shellcheck disable=2034
                LOGLEVEL=1
                ;;
            -dd|--debug) 
                ## ### -dd
                ## ### --debug
                ##
                ## Enable trace logging (`$LOGLEVEL=2`).
                ##
                # shellcheck disable=2034
                LOGLEVEL=2
                ;;
            -ddd|--trace) 
                ## ### -ddd
                ## ### --trace
                ##
                ## Enable trace logging (`$LOGLEVEL=2`) and print every statement as it is executed.
                ##
                # shellcheck disable=2034
                LOGLEVEL=2
                set -x
                ;;
        esac
        shift
    done

    if [[ "$1" && "$1" == "-" ]] ; then infile=/dev/stdin
    elif [[ "$1"              ]] ; then infile="$1"
    elif [[ -e "README.md"    ]] ; then infile="README.md"
    else _error "No file or stdin passed"; fi

    if [[ $IN_PLACE && "$infile" = "/dev/stdin" ]];then
        usage "Cannot edit STDIN in-place"
        exit 1
    fi

    COMMENT_STYLE=${COMMENT_STYLE:-$(_detect_comment_style "$infile")}
    if [[ -z "$COMMENT_STYLE" ]];then
        _error "Unable to detect comment style."
    fi
    COMMENT_START=${COMMENT_START:-${COMMENT_STYLE_START[$COMMENT_STYLE]}}
    COMMENT_END=${COMMENT_END:-${COMMENT_STYLE_END[$COMMENT_STYLE]}}
    _debug 1 "COMMENT_STYLE=$COMMENT_STYLE"
    _debug 1 "COMMENT_START=$COMMENT_START"
    _debug 1 "COMMENT_END=$COMMENT_END"
    _debug 1 "infile=$infile"
}

#
# main
#

_parse_args "$@"

# first pass
tempfile1=$(mktemp --tmpdir)
_debug 1 "tempfile1=$tempfile1"
trap 'rm $tempfile1' EXIT INT TERM
_parse_lines 1 "$infile" > "$tempfile1"

# second pass
tempfile2=$(mktemp --tmpdir)
_debug 1 "tempfile2=$tempfile2"
trap 'rm $tempfile2' EXIT INT TERM
_parse_lines 2 "$tempfile1" > "$tempfile2"

if [[ $IN_PLACE ]];then
    cp "$tempfile2" "$infile"
else
    cat "$tempfile2"
fi

#
# main
#

## ## OPTIONS
_parse_args() {

    while [[ "$1" != '-' && "$1" = -* ]];do
        case "$1" in
            -h)
                ## ### -h, --help
                ##
                ## help
                ##
                usage
                exit ;;
            -i|--inplace)
                ## ### -i, --inplace
                ##
                ## Edit the file in-place
                ##
                IN_PLACE=true 
                ;;
            -p|--shinclude-path)
                ## ### -p, --shinclude-path PATH
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
                ## ### -c, --comment-style COMMENT_STYLE
                ##
                ## Comment style. See [COMMENT STYLES](#comment-styles).
                ##
                COMMENT_STYLE="$2"; shift
                ;;
            -cs|--comment-start)
                ## ### -cs, --comment-start COMMENT_START
                ##
                ## Comment start. Overrides language-specific comment start.
                ##
                ## See [COMMENT STYLES](#comment-styles).
                ##
                COMMENT_START="$2"; shift
                ;;
            -ce|--comment-end)
                ## ### -ce, --comment-end COMMENT_END
                ##
                ## Comment end. Overrides language-specific comment end.
                ##
                ## See [COMMENT STYLES](#comment-styles).
                ##
                COMMENT_END="$2"; shift
                ;;
            -d|--info)
                ## ### -d, --info
                ##
                ## Enable debug logging ([`$LOGLEVEL=1`](#loglevel))
                ##
                # shellcheck disable=2034
                LOGLEVEL=1
                ;;
            -dd|--debug) 
                ## ### -dd, --debug
                ##
                ## Enable trace logging (`$LOGLEVEL=2`).
                ##
                # shellcheck disable=2034
                LOGLEVEL=2
                ;;
            -ddd|--trace) 
                ## ### -ddd, --trace
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
    else shlog -l error -x 2 "No file or stdin passed"; fi

    if [[ $IN_PLACE && "$infile" = "/dev/stdin" ]];then
        usage "Cannot edit STDIN in-place"
        exit 1
    fi

    COMMENT_STYLE=${COMMENT_STYLE:-$(_detect_comment_style "$infile")}
    if [[ -z "$COMMENT_STYLE" ]];then
        shlog -l error -x 2 "Unable to detect comment style."
    fi
    COMMENT_START=${COMMENT_START:-${COMMENT_STYLE_START[$COMMENT_STYLE]}}
    COMMENT_END=${COMMENT_END:-${COMMENT_STYLE_END[$COMMENT_STYLE]}}
    shlog -l debug "COMMENT_STYLE=$COMMENT_STYLE"
    shlog -l debug "COMMENT_START=$COMMENT_START"
    shlog -l debug "COMMENT_END=$COMMENT_END"
    shlog -l debug "infile=$infile"
}

_parse_args "$@"

# first pass
tempfile1=$(mktemp --tmpdir)
shlog -l debug "tempfile1=$tempfile1 (pass 1)"
trap 'rm $tempfile1' EXIT INT TERM
_read_lines 1 "$infile" > "$tempfile1"

# second pass
tempfile2=$(mktemp --tmpdir)
shlog -l debug "tempfile2=$tempfile2 (pass 2)"
trap 'rm $tempfile2' EXIT INT TERM
_read_lines 2 "$tempfile1" > "$tempfile2"

if [[ $IN_PLACE ]];then
    cp "$tempfile2" "$infile"
else
    cat "$tempfile2"
fi


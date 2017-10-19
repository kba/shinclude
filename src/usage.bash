# ### usage
#
# Show usage
#
usage() {
  echo "Usage: $0 [options] [input-file...]"
  [[ ! -z "$1" ]] && echo -e "\n!! $* !!\n"
  echo '
    Options:
        -h --help
            Show this help
        -i --inplace 
            Replace blocks in-place instead of writing to STDOUT
        -p --shinclude-path
            Add this file to the search path for referenced files
        -c --coment-style STYLE
            Use this comment style for detecting block delimiters.
            Use `-c list` to get a list of available styles.
        -cs --comment-start STRING
            Use this string for comment start tokens
        -ce --comment-end STRING
            Use this string for comment end tokens
        -d -dd -ddd
            Enable increasingly verbose debug logging.

    Input File:
        If input-file is "-", read from STDIN.
        If no input-file is given, assume "./README.md"

    Logging:
        shinclude logs with shlog. See https://github.com/kba/shlog
        To set the default logging level, set the SHLOG_TERM environment var:

        SHLOG_TERM=info shinclude ...'
}


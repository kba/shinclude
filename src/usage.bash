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


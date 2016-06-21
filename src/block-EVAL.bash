## ### EVAL
##
## Evaluates the arguments as a shell expression. **BE CAREFUL**
##
## EVAL Runs on **first** pass
## 
##     # BEGIN-EVAL wc *
##     # END-EVAL
## 
## 
## will be transformed to
## 
##     # BEGIN-EVAL wc *
##
##       21   171  1085 LICENSE
##       51   106   978 Makefile
##      290   461  4058 README.md
##      558  1267 12212 shinclude
##      275   828  5565 shinclude.1
##     1723  4100 36080 total
##
##     # END-EVAL
##
typeset -A BLOCK_PASS
# shellcheck disable=2034
BLOCK_PASS[EVAL]=1

shinclude-block-EVAL () {
    local blockargs
    blockargs="$1"
    printf "%s" "$(eval "${blockargs//\//\/}")" 
}

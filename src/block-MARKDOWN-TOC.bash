## ### MARKDOWN-TOC
##
## Reads in the file and outputs a table of contents of
## the markdown headings.
##
## Runs on **second** pass
##
##     # First Heading
##
##     []: BEGIN-MARKDOWN-TOC
##     []: END-MARKDOWN-TOC
##
##     ## Second-Level Heading
##
## will be transformed to 
##
##     # First Heading
##
##     []: BEGIN-MARKDOWN-TOC
##
##     * [First Heading](#first-heading)
##     	* [Second-Level  Heading](#second-level-heading)
##
##     []: END-MARKDOWN-TOC
##
##     ## Second-Level Heading

## Runs on first pass
typeset -A BLOCK_PASS
# shellcheck disable=2034
BLOCK_PASS[MARKDOWN-TOC]=2

## #### `$MARKDOWN_TOC_INDENT`
##
## String to indent a single level. Default: `\t`
##
MARKDOWN_TOC_INDENT=${MARKDOWN_TOC_INDENT:-	}

_heading_to_toc() {
    heading="$1"
    # shellcheck disable=2001
    indent=$(echo "${heading//[^#]/}" |sed 's/^##//')
    indent=${indent//\#/$MARKDOWN_TOC_INDENT}
    # shellcheck disable=2001
    link_text=$(echo "$heading" |sed  \
        -e 's/^#* //' \
    )
    link_target="${link_text,,}"
    link_target="${link_target//[\$\`()]/}"
    link_target="${link_target//[^A-Za-z0-9_]/-}"
    printf "%s* [%s](#%s)\n" \
        "$indent" \
        "$link_text" \
        "$link_target"
}

_block_MARKDOWN-TOC() {
    local blockargs block line infile
    infile="$3"
    IFS=$'\n'
    while read line;do
        if [[ "$line" =~ ^## ]];then
            _heading_to_toc "$line"
        fi
    done < "$infile"
    # for mdline in
}

## ### MARKDOWN-TOC
##
## ([source](./src/block-MARKDOWN-TOC.bash#L__CURLINE__), [test](./test/MARKDOWN-TOC))
##
## Reads in the file and outputs a table of contents of
## the markdown headings.

##
## Runs on **second** pass
##
typeset -A BLOCK_PASS
# shellcheck disable=2034
BLOCK_PASS[MARKDOWN-TOC]=2

##
##     # First Heading
##
##     [rem]: BEGIN-MARKDOWN-TOC
##     [rem]: END-MARKDOWN-TOC
##
##     ## Second-Level Heading
##
## will be transformed to (`shinclude -cs '[rem]:' -ce '' -`)
##
##     # First Heading
##
##     [rem]: BEGIN-MARKDOWN-TOC
##
##     * [First Heading](#first-heading)
##     	* [Second-Level  Heading](#second-level-heading)
##
##     [rem]: END-MARKDOWN-TOC
##
##     ## Second-Level Heading

## #### `$MARKDOWN_TOC_INDENT`
##
## String to indent a single level. Default: `\t`
##
MARKDOWN_TOC_INDENT=${MARKDOWN_TOC_INDENT:-	}

## #### `$HEADING_REGEX`
##
## Regex used to detect and tokenize headings.
##
## Default: `^(##+)\s*(.*)`
##
HEADING_REGEX='^(##+)\s*(.*)'

## #### Heading-to-Link algorithm
##
# shellcheck disable=2004
shinclude::markdown::heading_to_toc() {
    local indent link_text="$2" link_target
    pounds="$1"
    ## Replace markdown links in heading with just the link text
    link_text=$(echo "$link_text"|sed -E 's,\[([^\]*)\]\([^\)]*\),\1,')
    ## Link text: Remove `[ ]`
    # shellcheck disable=2001
    link_text=$(echo "$link_text" |tr -d '[]')
    ## Indentation: Concatenate `$MARKDOWN_TOC_INDENT` times  the number of leading `#`- 2
    ##
    indent=${pounds#\##}
    indent=${indent//\#/$MARKDOWN_TOC_INDENT}

    link_target=$(markdown-heading-anchor "$link_text")

    shlog -l trace "MARKDOWN-TOC: Link Text: '$link_text' Link level: '${#pounds}' Link target: '$link_target'"
    if [[ -n "$link_target" ]];then
        if [[ -z ${EXISTING_HEADINGS[$link_target]} ]];then
            EXISTING_HEADINGS["$link_target"]=1
        else
            link_target="${link_target}-${EXISTING_HEADINGS[$link_target]}"
            (( EXISTING_HEADINGS[${link_target%-*}] += 1 ))
        fi
    fi
    printf "%s* [%s](#%s)\n" \
        "$indent" \
        "$link_text" \
        "$link_target"
}

shinclude::block::MARKDOWN-TOC () {
    local line infile
    typeset -A EXISTING_HEADINGS
    EXISTING_HEADINGS=()
    infile="$3"
    IFS=$'\n'
    while read -r line;do
        if [[ $line =~ $HEADING_REGEX ]];then
            shinclude::markdown::heading_to_toc "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
        fi
    done < "$infile"
    shlog -l debug "MARKDOWN-TOC: $(declare -p EXISTING_HEADINGS)"
    # for mdline in
}

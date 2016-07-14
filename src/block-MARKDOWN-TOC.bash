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
    local heading indent link_text link_target
    pounds="$1"
    link_text="$2"
    shlog -l trace "MARKDOWN-TOC: Link Text: '$link_text' Link level: ${#pounds}"
    ## Indentation: Concatenate `$MARKDOWN_TOC_INDENT` times  the number of leading `#`- 2
    ##
    indent=${pounds#\##}
    indent=${indent//\#/$MARKDOWN_TOC_INDENT}
    ## Link target: Start with Link Text
    ##
    ## * lowercase
    ## * remove `` $ ` ( ) . ,``
    ## * Replace all non-alphanumeric characters with `-`
    ## * If link target not used previously
    ## * then set `EXISTING_HEADINGS[$link_target]` to `1`
    ## * else increase `EXISTING_HEADINGS[$link_target]` by one and concatenate
    ##
    link_target="${link_text,,}"
    link_target="${link_target//[\$\`()\.,%:\?]/}"
    link_target="${link_target//[^A-Za-z0-9_]/-}"
    if [[ -z ${EXISTING_HEADINGS[$link_target]} ]];then
        EXISTING_HEADINGS["$link_target"]=1
    else
        link_target="${link_target}-${EXISTING_HEADINGS[$link_target]}"
        (( EXISTING_HEADINGS[${link_target%-*}] += 1 ))
    fi
    printf "%s* [%s](#%s)\n" \
        "$indent" \
        "$link_text" \
        "$link_target"
}

shinclude::block::MARKDOWN-TOC () {
    local blockargs block line infile
    typeset -A EXISTING_HEADINGS
    EXISTING_HEADINGS=()
    infile="$3"
    IFS=$'\n'
    while read line;do
        if [[ $line =~ $HEADING_REGEX ]];then
            shinclude::markdown::heading_to_toc "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
        fi
    done < "$infile"
    shlog -l debug "MARKDOWN-TOC: $(declare -p EXISTING_HEADINGS)"
    # for mdline in
}

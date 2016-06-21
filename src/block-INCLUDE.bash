## ### INCLUDE
##
## Include data from a file.
##
## `INCLUDE` runs on **first** pass.
##
##     # BEGIN-INCLUDE LICENSE
##     # END-INCLUDE
##
## will be transformed to
##
##     # BEGIN-INCLUDE LICENSE
##     The MIT License (MIT)
##     
##     Copyright (c) 2016 Konstantin Baierer
##     
##     Permission is hereby granted, free of charge, to any person obtaining a copy
##     of this software and associated documentation files (the "Software"), to deal
##     in the Software without restriction, including without limitation the rights
##     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
##     copies of the Software, and to permit persons to whom the Software is
##     furnished to do so, subject to the following conditions:
##     
##     The above copyright notice and this permission notice shall be included in all
##     copies or substantial portions of the Software.
##     
##     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
##     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
##     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
##     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
##     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
##     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
##     SOFTWARE.
##     # END-INCLUDE
##
typeset -A BLOCK_PASS
# shellcheck disable=2034
BLOCK_PASS[INCLUDE]=1

shinclude-block-INCLUDE () {
    local blockargs includefile
    blockargs="$1"
    local IFS=$'\n'
    # shellcheck disable=2001
    for includefile in $(echo "$blockargs"|sed 's/,\s*/\n/g');do
        for dir in "${SHINCLUDE_PATH[@]}";do
            shlog -l trace "INCLUDE: Trying $dir/$includefile"
            if [[ -e "$dir/$includefile" ]];then
                shlog -l debug "INCLUDE: Including $includefile"
                cat "$dir/$includefile"
                break;
            fi
        done
    done
}

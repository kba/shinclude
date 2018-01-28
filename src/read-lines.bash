#
# main
#

# shellcheck disable=2094
shinclude::read_lines() {
  local pass line begin end blocktype blockargs block infile
  pass=$1
  infile=$2
  IFS=$'\n'
  local startPattern alternativeStartPattern
  startPattern="$COMMENT_START"
  alternativeStartPattern="${COMMENT_START_ALTERNATIVE:-$COMMENT_START}"

  while read -r line;do
    shlog -l info "line='${line:0:10}'"
    # shlog -l info "line='${line:10}' startPattern='$startPattern'"
    local currentStartPattern

    # shlog -l info "foo=$foo line=$line"
    if [[ "$line" = "${startPattern} BEGIN-"** ]];then
        currentStartPattern="$startPattern"
    fi
    # shlog -l info "currentStartPattern=$currentStartPattern"

    if [[ ! -z "$currentStartPattern" ]];then
      begin="$line"

      blocktype="${begin:${#currentStartPattern}:${#line}}"
      blocktype="${blocktype##*BEGIN-}"
      blocktype="${blocktype%$COMMENT_END}"
      blocktype="${blocktype%% *}"

      shlog -l info "currentStartPattern=$currentStartPattern alternativeStartPattern=$alternativeStartPattern"
      shlog -l info "blocktype=$blocktype"

      blockargs="${begin:${#currentStartPattern}:${#line}}"
      blockargs="${blockargs#*BEGIN-$blocktype}"
      blockargs="${blockargs# }"
      blockargs="${blockargs% $COMMENT_END}"
      shlog -l info "2 blockargs=$blockargs"

      block=""
      while
        read -r line \
          && [[ "$line" != "$alternativeStartPattern END-$blocktype"* \
          && "$line" != *"END-$blocktype $COMMENT_END"   ]]
      do
        printf -v block "%s\n%s" "$block" "$line"
      done
      # shlog -l info ">>>> $block"
      if ! declare -f -F "shinclude::block::$blocktype" >/dev/null;then
        shlog -l error -x 2 "No such block type '$blocktype'"
      fi
      if [[ ${BLOCK_PASS[$blocktype]} != $pass ]];then
        shlog -l debug "PASS $pass: SKIP '$blocktype' '$blockargs'"
        printf "%s%s\n%s\n" "$begin" "$block" "$line"
        continue;
      fi
      shlog -l debug "PASS $pass: RUN $blocktype '$blockargs'"
      shlog -l trace "PASS $pass: RUN $blocktype '$blockargs' '$block'"
      newblock="$("shinclude::block::$blocktype" "$blockargs" "$block" "$infile")"
      ret=$?
      if [[ $ret != 0 ]];then
        shlog -l error -x 2 "$ret: Error running '$blocktype' '$blockargs'"
      fi
      printf "%s\n%s\n\n%s\n" "$begin" "$newblock" "$line"
    else
      shlog -l trace "PASS $pass: (ign) $line"
      printf "%s\n" "$line"
    fi
  done < "$infile"
}

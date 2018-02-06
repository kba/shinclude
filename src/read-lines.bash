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
  endPattern="$COMMENT_END"
  alternativeStartPattern="${COMMENT_START_ALTERNATIVE:-$COMMENT_START}"

  while read -r line;do
    shlog -l debug "line='${line:0:10}'"
    # shlog -l info "line='${line:10}' startPattern='$startPattern'"
    # shlog -l info "foo=$foo line=$line"

    if [[ $pass = 0 && $line = "$startPattern HERE-"* ]];then
      local blocktype_and_blockargs blocktype
      blocktype_and_blockargs="${line##*HERE-}"
      blocktype_and_blockargs="${blocktype_and_blockargs%$COMMENT_END}"
      blocktype="${blocktype_and_blockargs%% *}"
      shlog -l error "$startPattern BEGIN-${blocktype_and_blockargs}\n"
      printf "$startPattern BEGIN-${blocktype_and_blockargs} $endPattern\n"
      printf "$alternativeStartPattern END-${blocktype} $endPattern\n"
    elif [[ "$line" = "${startPattern} BEGIN-"** ]];then
      begin="$line"

      blocktype="${begin:${#startPattern}:${#line}}"
      blocktype="${blocktype##*BEGIN-}"
      blocktype="${blocktype%$COMMENT_END}"
      blocktype="${blocktype%% *}"

      shlog -l debug "startPattern=$startPattern alternativeStartPattern=$alternativeStartPattern"
      shlog -l debug "blocktype=$blocktype"

      blockargs="${begin:${#startPattern}:${#line}}"
      blockargs="${blockargs#*BEGIN-$blocktype}"
      blockargs="${blockargs# }"
      blockargs="${blockargs% $COMMENT_END}"
      # shlog -l debug "2 blockargs=$blockargs"

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

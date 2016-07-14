#
# main
#

# shellcheck disable=2094
shinclude::read_lines() {
    local pass line begin end blocktype blockargs block infile
    pass=$1
    infile=$2
    IFS=$'\n'
    while read -r line;do
      if [[ "$line" = "$COMMENT_START BEGIN-"* ]];then
          begin="$line"

          blocktype="${begin:${#COMMENT_START}:${#line}}"
          blocktype="${blocktype##*BEGIN-}"
          blocktype="${blocktype%$COMMENT_END}"
          blocktype="${blocktype%% *}"

          blockargs="${begin:${#COMMENT_START}:${#line}}"
          blockargs="${blockargs#*BEGIN-$blocktype}"
          blockargs="${blockargs# }"
          blockargs="${blockargs% $COMMENT_END}"

          block=""
          while
              read -r line \
              && [[ "$line" != "$COMMENT_START END-$blocktype"* \
              && "$line" != *"END-$blocktype $COMMENT_END"   ]]
          do
              printf -v block "%s\n%s" "$block" "$line"
          done
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

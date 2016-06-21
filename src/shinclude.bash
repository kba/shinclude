#!/bin/bash

export SHINCLUDESHARE
SHINCLUDESHARE="$(dirname "${BASH_SOURCE[0]}")"
PATH="$PATH:$SHINCLUDESHARE/deps/bin"
source "$(which shlog)" || { echo 'Requires shlog'; exit 1; }
source "$(which shrender)" || { shlog -l error -x 1 'Requires shrender'; }

typeset -A BLOCK_PASS
typeset -a SHINCLUDE_PATH
SHINCLUDE_PATH=()
SHINCLUDE_PATH+=("$PWD")

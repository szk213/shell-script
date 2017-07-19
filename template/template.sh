#!/bin/bash
set -u

# @(#) template.sh ver.1.0.0 2017.07.20
#
# Usage:
#   template.sh param1 param2
#     param1 - パラメータ1です.
#     param2 - パラメータ2です.
#
# Description:
#   template.shスクリプトです.
#
###########################################################################

err() {
      echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

install_script() {
    # 処理
    return 1
}

install_script_fail() {
    # エラー処理
    err 'Error !'
    exit 1
}

install_script || install_script_fail

#!/usr/bin/env bash

# Copyright 2020 sukawasatoru
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eu

TMP_DIR=""

cleanup() {
  [[ -x $TMP_DIR ]] && rm -rf "$TMP_DIR"
  true
}

copy_assets() {
  local -r SRC="$1"
  local -r ASSETS_PATH="$2"
  local -r TARGET_DIR_IN_ASSETS="$3"
  local -r TARGET_STEM="$4"

  local -r BASENAME=$(basename "$1")

  # shellcheck disable=SC2001
  local -r EXTENSION=$(sed -e 's/\([^.]*\).\(.*\)/\2/' <<<"$BASENAME")

  for NUM in $(seq 1 10)
  do
    cp -v "$SRC" "$ASSETS_PATH/$TARGET_DIR_IN_ASSETS/$TARGET_STEM-$NUM.dataset/$TARGET_STEM-$NUM.$EXTENSION"
  done
}

copy_file() {
  local -r SRC="$1"
  local -r TARGET_DIR="$2"
  local -r TARGET_STEM="$3"

  local -r BASENAME=$(basename "$1")

  # shellcheck disable=SC2001
  local -r EXTENSION=$(sed -e 's/\([^.]*\).\(.*\)/\2/' <<<"$BASENAME")

  for NUM in $(seq 1 10)
  do
    cp -v "$SRC" "$TARGET_DIR/$TARGET_STEM-$NUM.$EXTENSION"
  done
}

trap cleanup EXIT

if ! command -v swiftlint > /dev/null
then
  echo "this project uses SwiftLint. please install SwiftLint and try again to continue."
  exit 1
fi

if ! command -v carthage > /dev/null
then
  echo "this project uses Carthage. please install Carthage and try again to continue."
  exit 1
fi

if [[ ${1:-} != -accept ]]; then
  echo "please accept license agreement and execute with \"-accept\" argument"
  open "https://soundeffect-lab.info/agreement/"
  exit
fi

TMP_DIR=$(mktemp -d)

SOUND1_URL="https://soundeffect-lab.info/sound/button/mp3/cursor2.mp3"
SOUND2_URL="https://soundeffect-lab.info/sound/button/mp3/decision3.mp3"

SOUND1_FILE="$TMP_DIR/$(basename $SOUND1_URL)"
SOUND2_FILE="$TMP_DIR/$(basename $SOUND2_URL)"

curl -sSfo "$SOUND1_FILE" "$SOUND1_URL"
curl -sSfo "$SOUND2_FILE" "$SOUND2_URL"

ASSETS_PATH="$PWD/AVAudioPlayerQueue/Assets.xcassets"
SOUNDS_DIR="$PWD/AVAudioPlayerQueue/Resources/sounds"

if [[ ! -x $SOUNDS_DIR ]]
then
  mkdir -p "$SOUNDS_DIR"
fi

copy_assets "$SOUND1_FILE" "$ASSETS_PATH" "sounds" se1
copy_assets "$SOUND2_FILE" "$ASSETS_PATH" "sounds" se2
copy_file "$SOUND1_FILE" "$SOUNDS_DIR" se1
copy_file "$SOUND2_FILE" "$SOUNDS_DIR" se2

carthage bootstrap --platform iOS

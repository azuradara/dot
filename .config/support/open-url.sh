#!/usr/bin/env bash

if [ "$(uname)" = "Darwin" ]; then
  open "$1"
else
  xdg-open "$1"
fi

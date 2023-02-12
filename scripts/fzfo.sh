#!/usr/bin/env bash

fzf | xargs -0 -I{} xdg-open {}

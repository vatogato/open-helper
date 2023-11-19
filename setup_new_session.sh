#!/bin/bash


#todo: better loading of necessary ruby files

#todo: implement tmux session logic to another file
tmux new-session -d -s helper_$1
tmux send-keys -t 0.0  "ruby dmt_pry.rb $1" C-m
tmux attach-session -t 0.0

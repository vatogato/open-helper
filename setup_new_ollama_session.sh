
tmux new-session -d -s helper_$1
tmux split-window -h
tmux send-keys -t 0.1 'ollama serve' C-m
./setup_session.sh $1
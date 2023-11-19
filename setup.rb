#!/bin/bash


#todo: better loading of necessary ruby files

#todo: implement tmux session logic to another file

Tmux.create_session_detached(session.name)
Tmux.send_command()

session = Session.new("main")
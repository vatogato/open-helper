require_relative 'lib/active/tmux'
session = TmuxSession.create("pry_ollama")
window = session.windows.first
window.panes.first.send_command "ruby pry_ollama.rb"

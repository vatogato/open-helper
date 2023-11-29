require_relative 'lib/active/tmux'
session = TmuxSession.create("pry_llama")
window = session.windows.first
window.panes.first.send_command "ruby pry_llama.rb"
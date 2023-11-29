
require 'pry'  
require_relative 'lib/active/tmux'  # This line loads the Tmux module
# require_relative 'lib/active/prompt'  # This line loads the Tmux module
# require_relative 'lib/active/conversation' 
require_relative 'lib/active/pry_helper'
require_relative 'lib/active/ollama_session'
#todo: better loading of necessary ruby files

#todo: implement tmux session logic to another file

# session = Session.new("main")
# Tmux.helper_setup(session.name)
# Tmux.create_session_detached(session.name)
# Tmux.send_command()
PryHelper::Hooks.helper
session = OllamaSession.new("pry_ollama", TmuxSession.load_from_name("pry_ollama"))
PryHelper::Hooks.ollama(session)

Pry.start(session.get_binding)



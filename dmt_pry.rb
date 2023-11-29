

# dmt_pry.rb
#don't mean to pry, ßut
require 'pry'  
require_relative 'lib/active/tmux'  # This line loads the Tmux module
require_relative 'lib/active/prompt'  # This line loads the Tmux module
require_relative 'lib/active/conversation' 
require_relative 'lib/active/pry_helper'
require_relative 'lib/active/ollama_session'
#todo: better loading of necessary ruby files

#todo: implement tmux session logic to another file

# session = Session.new("main")
# Tmux.helper_setup(session.name)
# Tmux.create_session_detached(session.name)
# Tmux.send_command()

  session_type = ARGV[0]
  Pry.main.extend(Tmux)
  PryHelper::Hooks.helper
  session = OllamaSession.new(session_type)
  PryHelper::Hooks.llm(session)

  Pry.start(session.get_binding)



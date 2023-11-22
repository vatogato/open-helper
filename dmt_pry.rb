

# dmt_pry.rb
#don't mean to pry, ßut
require 'pry'  
require 'faraday'
require 'langchain'
require_relative 'lib/active/tmux'  # This line loads the Tmux module
require_relative 'lib/active/prompt'  # This line loads the Tmux module
require_relative 'lib/active/conversation' 
require_relative 'lib/active/pry_helper'
#todo: better loading of necessary ruby files

class Session
# create llm client from LLM Module
LLM_MODELS = { completions: 'mistral-openorca',
           embeddings: 'mistral-openorca',
           qa: 'mistral-openorca' }

LLM_SERVER_BASE_URL ||= ENV['llm_URL'] || 'http://localhost:11434'

attr_reader :name
attr_reader :conversation

def initialize(name)
  @name = "helper_#{name}"
  @llm_models = LLM_MODELS
  @llm_url = LLM_SERVER_BASE_URL
  @conversation = Conversation.new(@name)
end

#todo: probably shouldn't expose this outside class idk
def llm_client(url = @llm_url)
  client = Langchain::LLM::Ollama.new(url: url)
end

def completions_model
  @llm_models[:completions]
end


def get_binding
  binding
end

#todo: proper class encapsulation or something whatever

end

#todo: implement tmux session logic to another file

# session = Session.new("main")
# Tmux.helper_setup(session.name)
# Tmux.create_session_detached(session.name)
# Tmux.send_command()

  session_type = ARGV[0]
  Pry.main.extend(Tmux)
  PryHelper::Hooks.helper
  session = Session.new(session_type)
  PryHelper::Hooks.llm(session.llm_client, session.completions_model)

  Pry.start(Session.new(session_type).get_binding)



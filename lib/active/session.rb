require 'pry'  
require 'faraday'
require 'langchain'
require_relative 'tmux'  # This line loads the Tmux module
require_relative 'prompt'  # This line loads the Tmux module
require_relative 'conversation' 
#todo: better loading of necessary ruby files

class Session
# create ollama client from LLM Module
MODELS = { completions: 'mistral-openorca',
           embeddings: 'mistral-openorca',
           qa: 'mistral-openorca' }

OLLAMA_URL ||= ENV['OLLAMA_URL'] || 'http://localhost:11434'

attr_reader :name
def initialize(name)
  @name = "helper_#{name}"
  @ollama_models = MODELS
  @ollama_url = OLLAMA_URL
  @conversation = Conversation.new
end

#todo: probably shouldn't expose this outside class idk
def self.ollama_client(url = @ollama_url)
  client = Langchain::LLM::Ollama.new(url: url)
end


#todo: move this into Pry hooks
def self.setup
  puts "Setting up Helper Pry session #{@name}"
  Pry.main.extend(Tmux)
end

def self.start
  puts "starting Pry with binding"
  Pry.start(binding)
end

#todo: same
#todo: configurable verbosity for output
def self.teardown
  puts "tearing down Pry for #{@name}"
  Tmux.end_session(@name) 
end

def self.run(name)
  puts "running"
  setup
  start
  teardown
end

def get_binding
  binding
end

#todo: proper class encapsulation or something whatever


end
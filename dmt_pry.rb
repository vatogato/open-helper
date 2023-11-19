

# dmt_pry.rb
#don't mean to pry, ßut
require 'pry'  
require 'faraday'
require 'langchain'
require_relative 'lib/active/tmux'  # This line loads the Tmux module
require_relative 'lib/active/prompt'  # This line loads the Tmux module
require_relative 'lib/active/conversation' 
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

#todo: implement tmux session logic to another file

# session = Session.new("main")
# Tmux.helper_setup(session.name)
# Tmux.create_session_detached(session.name)
# Tmux.send_command()

session_name = ARGV[1]
if ARGV[0] == "start_tmux"
  
  Tmux.create_detached_session(session_name)
  Tmux.send_command(session_name, "ruby ./dmt_pry.rb #{session_name} run_pry")
elsif ARGV[0] == "run_pry"
  puts "in dmt run"
  Tmux.attach_session(session_name)
  Session.new(session_name).run
end


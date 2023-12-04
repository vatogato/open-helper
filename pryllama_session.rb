require_relative 'tmux'
require 'pry'
require 'cli/ui'
require_relative "globals"
require 'langchain'
require 'faraday'
require_relative 'conversation' 

class PryllamaSession

  OLLAMA_MODELS = { completions: 'mistral-openorca',
                 embeddings: 'mistral-openorca',
                 qa: 'mistral-openorca' }

  OLLAMA_SERVER_BASE_URL ||= ENV['OLLAMA_SERVER_BASE_URL'] || 'http://localhost:11434'

  attr_reader :conversation

  #todo: just realized this wont work for sesssions with multiple llm sources involved
  # or at least it'll work weirdly.  need. to decouple the logic of llm source 

  def initialize(name, tmux_session = nil)
    @name = name
    @tmux_session = tmux_session
    @ollama_models = OLLAMA_MODELS
    @ollama_url = OLLAMA_SERVER_BASE_URL
    @conversation = Conversation.new(@name)


    #i think this makse sense because all LLM based interactions should use the abstraction of 
    # a conversation with all its context management necessities
  end

  # TODO: probably shouldn't expose this outside class idk
  # might as well go full llama in the meantime
  def langchain_client(url = @ollama_url)
    client = Langchain::LLM::Ollama.new(url: url)
  end

  def completions_model
    @ollama_models[:completions]
  end

  
  def models(type = nil)
    type.nil? ? @ollama_models : @ollama_models[type]
  end
  
  def context
    @conversation.full_context
  end

  def add_hooks

      Pry.hooks.add_hook(:before_session, 'pryllama_intro') do |output, binding, pry_instance|
      
      system("clear")
      pry_instance.prompt = Pry::Prompt.new('empty', 'No visible prompt', [proc { '' }, proc { '' }])
      puts "\n\nW E L C O M E  T O  PaRtY L L A M A  \n
      \n
      #comment to send a query to defaul Ollama model "
      end unless Pry.hooks.hook_exists?(:before_session, 'pryllama_intro')
    

    Pry.hooks.add_hook(:before_eval, 'check_response') do |input|
        
        if input[0] == "#" && input[1] != "#"
            conversation.add(input[1..-1])
            response = langchain_client.complete(prompt:conversation.full_context, model:completions_model)
            conversation.add(response.raw_response)

            Pry::output.puts "Query and Response added to Conversation context"
            
        end 
    end unless Pry.hooks.hook_exists?(:before_eval, 'check_response')

  end

  def add_commands
  #define any custom commands here.  I don't know what the paradigm for custom
  #pry commands vs Session method definitions will be.  Maybe Pry commands will be
  # Helper specific meta tools, idk.
  end

  def send_keys_to_pane(keys, id)
    @tmux_session.windows.first.panes.select{|p| p.id == id}.first.send_keys(keys)
  end

  def send_command_to_pane(command, id)
    @tmux_session.windows.first.panes.select{|p| p.id == id}.first.send_command(command)
  end


  def self.start(name)
    tmux_session = TmuxSession.create(name, script:'ruby session.rb ')
    PryllamaSession.new("pryllama", tmux_session).start
  end

  def start
    add_hooks
    add_commands

    Pry.start(binding)
  end

  # TODO: proper class encapsulation or something whatever
end


PryllamaSession.start("pryllama")

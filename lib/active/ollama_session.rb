require 'langchain'
require 'faraday'
require_relative 'conversation' 
require_relative 'session'
#todo: better loading of necessary ruby files

class OllamaSession < Session
  # create llm client from LLM Module
  OLLAMA_MODELS = { completions: 'mistral-openorca',
                 embeddings: 'mistral-openorca',
                 qa: 'mistral-openorca' }

  OLLAMA_SERVER_BASE_URL ||= ENV['OLLAMA_SERVER_BASE_URL'] || 'http://localhost:11434'

  attr_reader :conversation

  #todo: just realized this wont work for sesssions with multiple llm sources involved
  # or at least it'll work weirdly.  need. to decouple the logic of llm source 
  def initialize(name, tmux_session)
    super(name, tmux_session, 'ollama')
    @name = name
    @ollama_models = OLLAMA_MODELS
    @ollama_url = OLLAMA_SERVER_BASE_URL
    @conversation = Conversation.new(@name)
    #i think this makse sense because all LLM based interactions should use the abstraction of 
    # a conversation with all its context management necessities
  end

  # TODO: probably shouldn't expose this outside class idk
  # might as well go full llama in the meantime
  def ollama_client(url = @ollama_url)
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

  # def send_context_to_output_window
  #   output_to_window(@conversation.full_context)
  # end

  # TODO: proper class encapsulation or something whatever
end
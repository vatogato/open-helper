require_relative 'tmux'
require 'pry'
require 'cli/ui'
require_relative "globals"
require 'langchain'
require 'faraday'
require_relative 'prompt'
require_relative 'conversation'
require_relative 'ollama'
require_relative 'context_helper'

module Langchain::LLM
  # Interface to Ollama API.
  # Available models: https://ollama.ai/library
  #
  # Usage:
  #    ollama = Langchain::LLM::Ollama.new(url: ENV["OLLAMA_URL"])
  #
  class Ollama < Base
    attr_reader :url

    DEFAULTS = {
      temperature: 0.0,
      completion_model_name: "llama2",
      embeddings_model_name: "llama2"
    }.freeze

    # Initialize the Ollama client
    # @param url [String] The URL of the Ollama instance
    def initialize(url:)
      @url = url
    end

    #
    # Generate the completion for a given prompt
    #
    # @param prompt [String] The prompt to complete
    # @param model [String] The model to use
    # @param options [Hash] The options to use (https://github.com/jmorganca/ollama/blob/main/docs/modelfile.md#valid-parameters-and-values)
    # @return [Langchain::LLM::OllamaResponse] Response object
    #
    def complete(prompt:, model: nil, system_prompt:nil, **options)
      response = +""

      model_name = model || DEFAULTS[:completion_model_name]

      client.post("api/generate") do |req|
        req.body = {}
        req.body["prompt"] = prompt
        req.body["model"] = model_name
        req.body["system"] = system_prompt 

        req.body["options"] = options if options.any?

        # TODO: Implement streaming support when a &block is passed in
        req.options.on_data = proc do |chunk, size|
          json_chunk = JSON.parse(chunk)

          unless json_chunk.dig("done")
            response.to_s << JSON.parse(chunk).dig("response")
          end
        end
      end

      Langchain::LLM::OllamaResponse.new(response, model: model_name)
    end

end
end

class PryllamaSession

  OLLAMA_SERVER_BASE_URL ||= ENV['OLLAMA_SERVER_BASE_URL'] || 'http://localhost:11434'

  attr_reader :conversation
  attr_accessor :completions_model, :embeddings_model

  #todo: just realized this wont work for sesssions with multiple llm sources involved
  # or at least it'll work weirdly.  need. to decouple the logic of llm source 

  def initialize(name, tmux_session = nil)
    @name = name
    @tmux_session = tmux_session
    @completions_model = "codellama:7b-instruct-q4_0"
    @code_model = "codellama:7b-code-q4_0"
    @embeddings_model = "codellama:7b-instruct-q4_0"
    @ollama_url = OLLAMA_SERVER_BASE_URL
    @conversation = Conversation.new(@name)
    @prompt = Prompt.new("system", "main", "")


    #i think this makse sense because all LLM based interactions should use the abstraction of 
    # a conversation with all its context management necessities
  end

  def langchain_client(url = @ollama_url)
    client = Langchain::LLM::Ollama.new(url: url)
  end
  
  def context
    @conversation.full_context
  end

  def add_config

    original_print = Pry.config.print

    Pry.config.print = proc do |output, value, _pry_|
      original_print.call(output, value, _pry_)
      output.puts
    end

  end

  def generate(text)
    @conversation.add(text)

    #todo: add a spinner to indicate progress
    puts "sending query"
    response = langchain_client.complete(prompt:@conversation.full_context, model:completions_model, system_prompt:@prompt.text, temperature:0.2)
    @conversation.add(response.raw_response)

    first_window.panes.last.send_keys @conversation.context.last
  end

  def generate_code_fim(prefix, suffix)
    prompt = "<PRE> {#{prefix}} <SUF>{#{suffix}} <MID>"

    puts "sending query"
    @conversation.add(prompt)
    response = langchain_client.complete(prompt:prompt, model:@code_model)
    @conversation.add(response.raw_response)

    first_window.panes.last.send_keys @conversation.context.last
  end

  def ollama
    Ollama
  end

  def full_context
    @conversation.full_context
  end

  def add_hooks

      Pry.hooks.add_hook(:before_session, 'pryllama_intro') do |output, binding, pry_instance|
      
      system("clear")
      first_window.split_h
      first_window.panes.last.resize("R", 20)
      first_window.panes.last.send_command("vim current_context")
      first_window.panes.last.send_keys("i")



      pry_instance.prompt = Pry::Prompt.new('empty', 'No visible prompt', [proc { '' }, proc { '' }])
      puts "\n\nW E L C O M E  T O  PaRtY L L A M A \n\n"
      puts "You are bound within a Pry session inside a PryllamaSession object\n\n"
      puts "You can run any ollama cli command with ollama.command_name('arg1', 'arg2')\n\n"
      puts "You can query the Ollama server by running:  generate()"
      end unless Pry.hooks.hook_exists?(:before_session, 'pryllama_intro')
    

    # Pry.hooks.add_hook(:before_eval, 'check_response') do |input|
    #     puts "\n"
    #     if input[0] == "#" && input[1] != "#"
    #         @conversation.add(input[1..-1])

    #         puts "sending query #{@conversation}"
    #         response = langchain_client.complete(prompt:@conversation.full_context, model:completions_model, system_prompt:@prompt.text, temperature:0.2)
    #         @conversation.add(response.raw_response)

    #         Pry::output.puts "Query and Response added to Conversation context"
            
    #     end 
    # end unless Pry.hooks.hook_exists?(:before_eval, 'check_response')

    Pry.hooks.add_hook(:after_eval, 'add_line') do |input|
      puts "\n"
  end unless Pry.hooks.hook_exists?(:before_eval, 'add_line')

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


  

  def first_window
    @tmux_session.windows.first
  end

  def start
    add_config
    add_hooks
    add_commands

    Pry.start(binding)
  end

  def self.start(name)
    tmux_session = TmuxSession.create(name, script:'ruby session.rb ')
    PryllamaSession.new("pryllama", tmux_session).start
  end

  # TODO: proper class encapsulation or something whatever
  # todo:  method missing to dynamically call Tmux window commands
end


PryllamaSession.start("pryllama")

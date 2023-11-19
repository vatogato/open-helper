require 'cli/ui'
require 'langchainrb'
require 'faraday'

# standard REPL for a cli too hellol

# create ollama client from LLM Module
MODELS = { completions: 'mistral-openorca',
           embeddings: 'mistral-openorca',
           qa: 'mistral-openorca' }

OLLAMA_URL ||= ENV['OLLAMA_URL'] || 'http://localhost:11434'

def ollama_client(url = OLLAMA_URL)
  client = Langchain::LLM::Ollama.new(url: url)
end


def ask_the_llama(_model = nil)
  query = CLI::UI.ask('What would you like to ask the Magic Llama?')

  res = ollama_client.complete(prompt: query)
  puts "magic llama says: #{res.raw_response}"
end

CLI::UI::StdoutRouter.enable

# options

def help
  CLI::UI::Frame.open('Contents') do
    res = CLI::UI.ask('How can I help you?')
    puts res
  end
end

def missing
  'bye!'
  quit
end

def quit
  puts 'bye'
  exit 0
end

# show what helper knows
def show; end

# teach helpersomething
def teach
  # things that can be taught
  # knowledge about a tool (what is it)
  # how to use a tool (how is it used)
end

CLI::UI::Frame.open('Helper') do
  CLI::UI::Prompt.ask('Choose an option.') do |handler|
    handler.option('help') { |selection| send(selection) }
    handler.option('show') { |selection| send(selection) }
    handler.option('ask_the_llama') { |selection| send(selection) }
  end
end

# # define method missing to catch handler selection methods dynamically
# # Method to catch undefined methods and respond accordingly.
# def method_missing(_method_name, *_arguments)
#   # Check if the method name corresponds to an expected command.
#   'missing'
# end

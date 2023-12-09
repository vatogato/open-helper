require 'faraday'
require 'json'

class CodeEmbedder
  DEFAULTS = { embeddings_model_name: 'llama2' }

  # Initialize with the URL of the embeddings service
  def initialize(url)
    @url = url
  end

  # Generates an embedding for a given text using a specified model
  def embed(text:, model: nil, **options)
    model_name = model || DEFAULTS[:embeddings_model_name]

    response = client.post("api/embeddings") do |req|
      req.body = {}
      req.body["prompt"] = text
      req.body["model"] = model_name
      req.body["options"] = options if options.any?
    end

    # Assuming Langchain::LLM::OllamaResponse is a defined class
    Langchain::LLM::OllamaResponse.new(response.body, model: model_name)
  end

  private

  # @return [Faraday::Connection] Faraday client
  def client
    @client ||= Faraday.new(url: @url) do |conn|
      conn.request :json
      conn.response :json
      conn.response :raise_error
    end
  end
end

# Usage example
# embedder = CodeEmbedder.new('http://localhost:11434')
# response = embedder.embed(text: "def example_method\n  puts 'Hello, world!'\nend")
# puts response.embedding  # Assuming the response has an 'embedding' method or attribute

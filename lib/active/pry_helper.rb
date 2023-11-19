module PryHelper
  module PryHelper::Hooks

    def self.main
        helper
        ollama
    
    end

    def self.helper
        Pry.hooks.add_hook(:before_session, 'no_prompt') do |output, binding, pry_instance|
            pry_instance.prompt = Pry::Prompt.new('empty', 'No visible prompt', [proc { '' }, proc { '' }])
        end
    end

    def self.ollama(ollama_client, completions_model)
        Pry.hooks.add_hook(:before_eval, 'check_ollama') do |input|
            if input[0] == "#" && input[1] != "#"
            
                response = ollama_client.complete(prompt:input[1..-1], model:completions_model)
                Pry::output.puts "Ollama response: #{response.raw_response}"
                throw :pry_rc
            end        
        end
    end

#method to list prompts from Prompt

#method to get 
 
end


end
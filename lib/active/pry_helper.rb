module PryHelper
  module PryHelper::Hooks
    require 'tmux'

    def self.main
        helper
        llm
    
    end

    def self.helper
        Pry.hooks.add_hook(:before_session, 'no_prompt') do |output, binding, pry_instance|
            pry_instance.prompt = Pry::Prompt.new('empty', 'No visible prompt', [proc { '' }, proc { '' }])
        end

        Pry.hooks.add_hook(:before_session, 'clear_and_welcome') do 
            system("clear")
            puts "How can I help you?\n\n"
        end
    end

    def self.llm(llm_client, completions_model)
        Pry.hooks.add_hook(:before_eval, 'check_response_type') do |input, pry_instance|
            if input[0] == "#" && input[1] != "#"
            
                response = llm_client.complete(prompt:input[1..-1], model:completions_model)
                Pry::output.puts "llm response: #{response.raw_response}"

            end 
        end
    end

#method to list prompts from Prompt

#method to get 
 
end


end
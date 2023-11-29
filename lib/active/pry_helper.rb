module PryHelper
  module PryHelper::Hooks
    require_relative 'tmux'

    # def self.main
    #     helper
    #     llm
    
    # end

    def self.helper
        Pry.hooks.add_hook(:before_session, 'clear_and_welcome') do |output, binding, pry_instance|
            pry_instance.prompt = Pry::Prompt.new('empty', 'No visible prompt', [proc { '' }, proc { '' }])
            system("clear")
            puts "Welcome to Helper.\n\n"
        end
    end

    def self.llm(session)
        Pry.hooks.add_hook(:before_session, 'llm_intro') do |output, binding, pry_instance|
            pry_instance.prompt = Pry::Prompt.new('empty', 'No visible prompt', [proc { '' }, proc { '' }])
            puts "\n\nW E L C O M E  T O  PaRtY L L A M A  \n
            \n
            #comment to send a query to defaul Ollama "
            
        end

        Pry.hooks.add_hook(:before_eval, 'check_response') do |input|
            
            if input[0] == "#" && input[1] != "#"
                session.conversation.add(input[1..-1])
                response = session.ollama_client.complete(prompt:session.conversation.full_context, model:session.completions_model)
                session.conversation.add(response.raw_response)
                #session.send_context_to_output_window

                Pry::output.puts "Query and Response added to Conversation context"
                
            end 
        end

        # Pry.hooks.add_hook(:before_eval, 'catch_errors') do |input, pry_instance|
        #     begin
        #         # Attempt to evaluate the input
        #         eval(input, pry_instance.binding_stack.first)
        #         # Perform an action with the result if evaluation is successful
        #         # ...
        #       rescue StandardError => e
        #         # Handle the error and perform an action
        #         response = llm_client.complete(prompt:input, model:completions_model)
                
        #         Pry::output.puts "#{response.raw_response}"
        #         #Pry::output.puts "An error occurred: #{e.message}"
        #         # Perform an action in response to the error
        #         # ...
        #         #throw :pry_rc
                
        #       end
             
        # end

    end

#method to list prompts from Prompt

#method to get 
 
end

    module PryHelper::Commands


    end


end
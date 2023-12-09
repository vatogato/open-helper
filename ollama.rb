require 'open3'
require 'faraday'
require 'json'
require 'html2text'


class Ollama 

    OLLAMA_LIBRARY_URL = "https://ollama.ai/library"

    def self.library_list
        puts "Getting library listing from Ollama website. This might fail if their website structure changes."
        begin
            res = Faraday.get(OLLAMA_LIBRARY_URL)
        rescue => e
            puts "Failed getting Ollama Library Listing at #{OLLAMA_LIBRARY_URL}: #{e.to_json}"
            return nil
        end

        begin
            lines = Html2Text.convert(res.body)
        rescue => e
            puts "Failed parsing #{res.body} : #{e.to_json}"
        end
        

        lines.split("\n").select{|x| x.include? "/library/"}.map{|x| x.split("/library").last.delete("/\)")}

    end

    def self.list_model_tags(model)
    puts "Getting tags for model #{model}"
    puts "Getting library listing from Ollama website. This might fail if their website structure changes."
        begin
            res = Faraday.get(OLLAMA_LIBRARY_URL + "/#{model}/tags")
        rescue => e
            puts "Failed getting #{model} tag Listing at #{OLLAMA_LIBRARY_URL} : #{e.to_json}"
            return nil
        end

        begin
            lines = Html2Text.convert(res.body)
        rescue => e
            puts "Failed parsing #{res.body} : #{e.to_json}"
        end

        lines.split("\n").select{|x| x.include? "/library/"}.map{|x| x.split("/library").last.delete("/\)")}

    end

    def self.show_model_info(model, param)
        Ollama.show(model, "--#{param}")
    end


    #change the following implementation
    #to use method missing for all
    #ollama related commands
    # def self.list
    #     res = Ollama.command("list")
    #     rows = res.split("\n")
    #     headers = rows.first.split("\t").map(&:strip)
    #     data = rows[1..-1].map { |row| headers.zip(row.split("\t").map(&:strip)).to_h }
    # end


    def self.command(command, args = nil)
        command += " #{args}" if args
        response = Ollama.osys(command)
    end

    #expects Open3.capture3 response object
    def self.parse_osys_response(response)
        
        rows = response.first.split("\n")
        headers = rows.first.split("\t").map(&:strip)
        data = rows[1..-1].map { |row| headers.zip(row.split("\t").map(&:strip)).to_h }

    end

    def self.osys(command)

        begin
            response = Open3.capture3('ollama ' + command)
        rescue => e
            puts "Failed calling #{command}: #{e.to_json}"
        end
        Ollama.parse_osys_response(response)
    end 

    def self.method_missing(method_name, *arguments, &block)
        args = arguments.join(' ')
        
    
        if block_given?
          yield(Ollama.command("#{method_name} #{args}"))
        elsif method_name.to_s.include? "and_return"
            Ollama.command("#{method_name.to_s.split("_").first} #{args}")
        else
           command = method_name.to_s
           command += " #{args}" if args
           puts Ollama.osys(command)
        end
      end

    def self.respond_to_missing?(method_name, include_private = false)
        true
    end

end



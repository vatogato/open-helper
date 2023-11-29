require 'open3'
require 'faraday'
require 'json'
require 'pry'
require 'html2text'

module Ollama

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

def self.list_tags(model)
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

    lines.select{|line| line.include? "/library/"}

end


def self.command(command)
    Ollama.sys(command)

end

#expects Open3.capture3 response object
def self.parse_osys_response(response)
    
    raw = response.first
    code = response.last.exitstatus
    return false unless code == 0
    

end

def self.osys(command)

    begin
        response = Open3.capture3(command)
    rescue => e
        puts "Failed calling #{command}: #{e.to_json}"
    end
  Ollama.parse_osys_response(response)
end 
binding.pry
end



class Prompt
#everything stored in raw flat files for text manipulation
#todo: create json or yaml wrapper abstractions
       #that return the object based on file contents


#todo: proper encapsulation into type system
#modes always includes the default

@@PROMPTS_DIR_PATH="./"

attr_reader :type, :name
attr_accessor :mode

def initialize(type,name,text, variables:{})
  @type = type
  @name = name
  @text = ""
  @variables = variables
end

def text
  return @text if @text and !@text.empty? 

  @text = Prompt.text(@type, @name)
end

def self.create(type, name, text)
  Prompt.new(type, name, text)
end


def self.text(type = nil, name = nil)
  method_params = method(:text).parameters.map(&:last)
  method_params.each do |param|
    raise ArgumentError, "Parameter #{param} is missing or undefined" unless binding.local_variable_defined?(param)
  end

  get_prompt_text(type, name)
end

def self.get_prompt_filename(type, name)
  prompt_files.select do |filename| 
    
    filename.split("_")[1] == type && filename.split("_")[2] == name
  end
end


def self.get_prompt_text(type, name)
  
  if @text and !@text.empty?
    @text
  else

    begin
      `cat prompt_#{type}_#{name}.txt`.chomp  
    rescue => e
      "fatal error during cat command: #{e.to_s}"
    end
 
  end
end

def self.save_prompt(type, name, text)
  File.write("prompt_#{type}_#{name}.txt", text)
end

def self.prompt_files
  Dir.glob("prompt_*.txt")
end

def self.list_prompts
  list = prompt_files.map{|filename| filename.split("_")[2]}
  list.map{|prompt| puts prompt }
  list
end

end
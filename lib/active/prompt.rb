class Prompt
#everything stored in raw flat files for text manipulation
#todo: create json or yaml wrapper abstractions
       #that return the object based on file contents


#todo: proper encapsulation into type system
#modes always includes the default
#prompts dir structure is root/data/prompts/<type>/name_mode
@@PROMPTS = [{type: 'system', name:'main', modes:['default','polite']}]

@@PROMPTS_DIR_PATH="./data/prompts/"

attr_reader :type, :name
attr_accessor :mode

def initialize(type, name, mode = 'default', variables = {})
  @type = type
  @name = name
  @mode = mode
  @variables = variables
end

def text
  Prompt.text(@type, @name, @mode)
end

def modes
  Prompt.get_modes(@type, @name)
end


def self.get_modes(type, name)
  @@PROMPTS.select{|obj| obj[:type] == type && obj[:name] == name }.first[:modes]
end

def self.text(type = nil, name = nil, mode = 'default')
  method_params = method(:text).parameters.map(&:last)
  method_params.each do |param|
    raise ArgumentError, "Parameter #{param} is missing or undefined" unless binding.local_variable_defined?(param)
  end

  get_prompt_text(get_prompt_filenames(type, name, mode))
end

def self.get_prompt_filenames(type = nil,name = nil,mode = nil)
  #hey look at me i learned a thing.  will try and do this or abstract to 
  # a validator module or something
  unless mode.nil?
    return "#{@@PROMPTS_DIR_PATH}/#{type}/#{name}_#{mode}.txt"
  end

  method_params = method(:get_prompt_filenames).parameters.map(&:last)
  method_params.each do |param|
    raise ArgumentError, "Parameter #{param} is missing or undefined" unless binding.local_variable_defined?(param)
  end

  filenames = []
    @@PROMPTS.select{|obj| obj[:type] == type && obj[:name] == name }.each do |prompt|
        prompt[:modes].each do |mode|
            filenames << "#{prompt[:type]}_#{prompt[:name]}_#{mode}.txt"
        end
    end
    filenames
  end

  


def self.get_prompt_text(filepath)
  begin
    `cat #{filepath}`.chomp  
  rescue => e
    "fatal error during cat command: #{e.to_s}"
  end
end



end


require_relative 'prompt'

class Conversation
  #a Conversation is a cumulative context curated
  # over sessions.
  #todo:  different types of data within the context.
  # context will be the raw text and we can abstract
  #different data types for different types of discrete
  #units of context (pseudo embeddings)
  #marked trees of text blocks to allow the LLM to 
  #refer non-sequentially
  # this allows maximum context management on the application side
  # to remove as much unnecessary inference as possible
  # also allows the storage of important information for injection
  # at any point
  #
    
    attr_reader :name, :mode, :context
    def initialize(name, mode = 'default')
      @name = name
      @mode = mode
      @context = []
      @system_prompt = Prompt.new('system', @name, @mode )
    end

    def add(text)
      @context << text
    end

    def add_at(index, content)
      @context[index] = content
    end

    def remove_at(index)
        #leaves the index intact so we 
        #can see where context was removed
      ret = @context[index]
      @context[index] = nil
      ret
    end
    
    def remove_last_context_block
      remove_block_from_context(-1)
    end

    def full_context
      @context.join
    end

    def wipe_context
      @context = []
    end

end
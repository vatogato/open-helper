require 'faraday'
require 'html2text'

module ContextHelper

    
    def self.create_context_from_files(filenames)
        ContexttHelper.add_files_to_context([])
    end

    #need to change this to add some
    def self.add_file_to_context(context, filepath)
        file_contents = File.read(filepath)
        context << file_contents
    end

    def self.add_files_to_context(context, files)
        files.each do |file|
        add_file(context, file)  
        end
    end

    # Returns the filenames of all files with the given file type extension, for example, .rb files
    def self.get_repo_filenames(extension)
    Dir.glob("**/*#{extension}")
    end





module Reflective
    def reflect(other_object = nil)
      description = "This is a #{self.class} object. "
      description += "It has #{self.methods.count} methods. "
  
      if other_object
        common_methods = self.methods & other_object.methods
        description += "In relation to a #{other_object.class} object, they share #{common_methods.count} common methods. "
        description += "Shared methods include: #{common_methods.sort.join(', ')}."
      else
        description += "Public methods include: #{self.public_methods(false).sort.join(', ')}. "
        description += "Its ancestors are: #{self.class.ancestors.join(', ')}."
      end
  
      description
    end
  end

  require 'method_source'

  module Embeddable
    def embed
      content = extract_content(self)
      embedder.embed(content: content)
    end
  
    private
  
    def extract_content(object)
      case object
      when Class, Module
        object.instance_methods(false).map { |m| object.instance_method(m).source }.join("\n")
      when Method
        object.source
      else
        object.to_s
      end
    rescue MethodSource::SourceNotFoundError => e
      "Source not found for #{object}"
    end
  
    def embedder
      @embedder ||= CodeEmbedder.new('http://localhost:11434') # Replace with actual URL if different
    end
  end

# Example usage:
# SomeClassOrModule.extend(Embeddable)
# some_instance_or_method.extend(Embeddable)

    module DocumentationVectorization
        def self.extract_and_vectorize_comments(file_path)
        comments = extract_comments(file_path)
        embedder.embed(content: comments.join("\n"))
        end
    
        private
    
        def self.extract_comments(file_path)
        file_contents = File.readlines(file_path)
        file_contents.grep(/^#/)
        end
    
        def self.embedder
        @embedder ||= CodeEmbedder.new('http://localhost:11434')
        end
    end
    
  # Usage example
  # vectorized_comments = DocumentationVectorization.extract_and_vectorize_comments('example.rb')

  module ControlFlowGraphVectorization
    def self.create_and_vectorize_cfg(file_path)
      cfg = create_control_flow_graph(file_path)
      # Vectorize the CFG (this is a placeholder, actual implementation will depend on your CFG structure)
      embedder.embed(content: cfg.to_s)
    end
  
    private
  
    def self.create_control_flow_graph(file_path)
      # Placeholder for actual CFG creation logic
      # This should analyze the code and create a graph structure representing the control flow
      "Control Flow Graph for #{File.basename(file_path)}"
    end
  
    def self.embedder
      @embedder ||= CodeEmbedder.new('http://localhost:11434')
    end
  end
  
  # Usage example
  # vectorized_cfg = ControlFlowGraphVectorization.create_and_vectorize_cfg('example.rb')

  module APILibraryUsageVectorization
    def self.extract_and_vectorize_api_usage(file_path)
      api_usage = extract_api_library_calls(file_path)
      embedder.embed(content: api_usage.join("\n"))
    end
  
    private
  
    def self.extract_api_library_calls(file_path)
      file_contents = File.readlines(file_path)
      # This regex is a simple example and might need to be adapted for different languages or libraries
      file_contents.grep(/require\s+['"][\w\/]+['"]/)
    end
  
    def self.embedder
      @embedder ||= CodeEmbedder.new('http://localhost:11434')
    end
  end
  
  # Usage example
  # vectorized_api_usage = APILibraryUsageVectorization.extract_and_vectorize_api_usage('example.rb')

  module CodeChangeHistoryVectorization
    def self.vectorize_change_history(repo_path)
      change_history = extract_change_history(repo_path)
      embedder.embed(content: change_history.join("\n"))
    end
  
    private
  
    def self.extract_change_history(repo_path)
      # Placeholder for actual change history extraction logic
      # This should interact with a version control system to get the history
      # For example, using `git log` or similar commands
      ["Change 1", "Change 2", "Change 3"] # Example changes
    end
  
    def self.embedder
      @embedder ||= CodeEmbedder.new('http://localhost:11434')
    end
  end
  
  # Usage example
  # vectorized_history = CodeChangeHistoryVectorization.vectorize_change_history('/path/to/repo')

  require 'parser/current'

module ASTVectorization
  def self.create_and_vectorize_ast(file_path)
    ast = create_abstract_syntax_tree(file_path)
    # Convert the AST to a string representation (or another format suitable for vectorization)
    ast_string = ast_to_string(ast)
    embedder.embed(content: ast_string)
  end

  private

  def self.create_abstract_syntax_tree(file_path)
    Parser::CurrentRuby.parse(File.read(file_path))
  end

  def self.ast_to_string(ast)
    # Convert the AST to a string or another suitable representation
    ast.inspect
  end

  def self.embedder
    @embedder ||= CodeEmbedder.new('http://localhost:11434')
  end
end

# Usage example
# vectorized_ast = ASTVectorization.create_and_vectorize_ast('example.rb')

module ErrorHandlingVectorization
    def self.extract_and_vectorize_error_handling(file_path)
      error_handling_patterns = extract_error_handling_patterns(file_path)
      embedder.embed(content: error_handling_patterns.join("\n"))
    end
  
    private
  
    def self.extract_error_handling_patterns(file_path)
      file_contents = File.readlines(file_path)
      # Extract error and exception handling patterns
      # This regex is a simple example and might need to be adapted for different languages or patterns
      file_contents.grep(/rescue/)
    end
  
    def self.embedder
      @embedder ||= CodeEmbedder.new('http://localhost:11434')
    end
  end
  
  # Usage example
  # vectorized_error_handling = ErrorHandlingVectorization.extract_and_vectorize_error_handling('example.rb')
  
  module CodeMetricsVectorization
    def self.extract_and_vectorize_metrics(file_path)
      metrics = extract_code_metrics(file_path)
      # Convert metrics to a string or another format suitable for vectorization
      metrics_string = metrics.map { |key, value| "#{key}: #{value}" }.join("\n")
      embedder.embed(content: metrics_string)
    end
  
    private
  
    def self.extract_code_metrics(file_path)
      # Placeholder for actual code metrics extraction logic
      # This might include external tools or gems to analyze the code
      {
        lines_of_code: 100,  # Example metric
        number_of_methods: 10
        # Other metrics...
      }
    end
  
    def self.embedder
      @embedder ||= CodeEmbedder.new('http://localhost:11434')
    end
  end
  
  # Usage example
  # vectorized_metrics = CodeMetricsVectorization.extract_and_vectorize_metrics('example.rb')
  
  module TypeDataFlowVectorization
    def self.analyze_and_vectorize_data_flow(file_path)
      data_flow_analysis = analyze_data_flow(file_path)
      # Convert the data flow analysis to a string or another format suitable for vectorization
      data_flow_string = data_flow_analysis_to_string(data_flow_analysis)
      embedder.embed(content: data_flow_string)
    end
  
    private
  
    def self.analyze_data_flow(file_path)
      # Placeholder for actual data flow analysis logic
      # This should analyze the code to track how data is passed and transformed
      "Data Flow Analysis for #{File.basename(file_path)}"
    end
  
    def self.data_flow_analysis_to_string(analysis)
      # Convert the data flow analysis to a string or another suitable representation
      analysis
    end
  
    def self.embedder
      @embedder ||= CodeEmbedder.new('http://localhost:11434')
    end
  end
  
  # Usage example
  # vectorized_data_flow = TypeDataFlowVectorization.analyze_and_vectorize_data_flow('example.rb')
  
  
  
  

end
module ContexHelper

    
    #todo add separate methods for raw vs structured
    # or add structure in here, aka, instead of just
    # raw text files, added the filepath so the LLM
    #knows what file it is working with contextually
    def self.create_context_from_files(filenames)
        ContextHelper.add_files_to_context([])
    end


    def self.add_file_to_context(context, filepath)
        file_contents = File.read(filepath)
        context << file_contents
    end

    def self.add_files_to_context(context, files)
        files.each do |file|
        add_file(context, file)  
        end
    end

end
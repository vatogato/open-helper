require 'cli/ui'

CLI::UI::StdoutRouter.enable

# Main frame
CLI::UI::Frame.open('Pryllama Session', color: :green) do
    CLI::UI::Frame.open('Pryllama Session', color: :green) do
        # Left section for file directory
        CLI::UI::Frame.divider('File Directory')
        puts "file1.rb\nfile2.rb\nfile3.rb"

        # Middle section for code editor (simulation)
        CLI::UI::Frame.divider('Code Editor')
        puts "def hello_world\n  puts 'Hello, World!'\nend"

        # Right section for AI assistant's response (simulation)
        CLI::UI::Frame.divider('AI Assistant')
        puts "Suggestion: Use 'puts' for standard output."

        # Slim feedback bar simulation
        CLI::UI::Frame.divider('Feedback Bar')
        puts CLI::UI.fmt "{{error:Error: Something went wrong!}}"
    end
end

# To simulate real-time updates, you'd need to have a loop that refreshes the content
# This example is static for simplicity

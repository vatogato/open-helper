
#!/usr/bin/env ruby

require 'io/console'

# Function to run system commands and capture output
def run_command(command)
  `#{command}`.chomp
end

# Function to initiate a tmux session with IRB
def start_tmux_session_with_irb(session_name)
  system("tmux new-session -d -s #{session_name} irb")
end

# Function to send code to the tmux session running IRB
def send_code_to_tmux_irb(session_name, code)
  system(%Q[tmux send-keys -t #{session_name} "#{code}" C-m])
end

# Function to display the old-school MUCK styled interface
def display_muck_style_interface
  system("clear") || system("cls")
  puts "Welcome to the Ruby Code Runner MUCK Interface"
  puts "-" * 50
end

# Main loop for the CLI interface
def main_cli_loop
  session_name = 'code_runner_irb'
  start_tmux_session_with_irb(session_name)
  
  while true
    display_muck_style_interface
    puts "Enter Ruby code to execute or 'exit' to leave:"
    print "> "
    input = gets.chomp
    break if input.downcase == 'exit'

    # Send the code to the IRB session via tmux
    send_code_to_tmux_irb(session_name, input)
    puts "Code sent to IRB session. Check the tmux session '#{session_name}' for output."
    puts "Press any key to continue..."
    STDIN.getch
  end
  
  # Kill the tmux session when exiting
  run_command("tmux kill-session -t #{session_name}")
end

# Start the CLI loop
main_cli_loop

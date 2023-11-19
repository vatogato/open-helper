#!/usr/bin/env ruby

def activate_iterm2
  system("osascript -e 'tell application \"iTerm\" to activate'")
end

def generate_session_name
  "my_session_#{Time.now.to_i}"
end

def start_tmux_session_in_iterm(session_name)
  apple_script = <<-APPLESCRIPT
    tell application "iTerm"
      set newWindow to (create window with default profile)
      tell current session of newWindow
        write text "tmux new-session -s #{session_name}"
      end tell
    end tell
  APPLESCRIPT
  
  system("osascript -e '#{apple_script}'")
end

# Array to hold session names
session_names = []

# Helper method to create and store session names
def create_and_store_session_name(session_names)
  session_name = generate_session_name
  session_names << session_name
  session_name
end

# Main execution logic
activate_iterm2
session_name = create_and_store_session_name(session_names)
start_tmux_session_in_iterm(session_name)

# Output the session names array for future reference
puts "Active sessions: #{session_names}"

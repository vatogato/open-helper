require 'open3'

module Tmux
  # List all tmux sessions
  def self.list_sessions
    output, status = Open3.capture2('tmux list-sessions')
    status.success? ? parse_sessions_info(output) : nil
  end

  def self.parse_sessions_info(info)
    #todo move all data transformation logic paramters
    # to config files or their own methods so that a general
    # parse method can take a type parameter based on what
    # type of information is being parsed.
    info.split("\n").map{|x| {name:x.split(" ")[0].delete(":")}}
  end

  # Create a new tmux session

  def self.create_detached_session(session_name)
    self.create_session(session_name, true)
  end

  def self.create_session(session_name, detached = false)
    command = "tmux new-session" 
    command += " -d" if detached
    command += " -s #{session_name}"
    system(command)
  end 

  def self.attach_session(session_name)
    system("tmux attach-session -t #{session}")
  end

  def self.end_session(session_name) 
    system("tmux kill-session -t #{session_name}")
  end 

# Create a new window in a tmux session
  def self.create_window(session_name, window_name = nil)
    command = "tmux new-window"
    command += " -t #{session_name}" if session_name
    command += " -n #{window_name}" if window_name

    system(command)
  end

  # Send a command to a tmux session
  def self.send_command(session_name, command)
    system("tmux send-keys -t #{session_name} '#{command}' C-m")
  end

   # Send a command to a tmux session
   def self.send_input(session_name, input)
    system("tmux send-keys -t #{session_name} '#{input}'")
   end

   # Send a command to a tmux session
   def self.send_input_to_pane(pane_id, input)
    system("tmux send-keys -t #{pane_id} '#{input}'")
   end

  # Capture the output from a tmux session
  def self.capture_output(session_name, pane_id = 0)
    output, status = Open3.capture2("tmux capture-pane -pt #{session_name}:#{pane_id}")
    status.success? ? output : nil
  end

  # List panes in a tmux session
  def self.list_panes(session_name)
    output, status = Open3.capture2("tmux list-panes -t #{session_name}")
    status.success? ? output : nil
  end

  # Split a pane in a tmux session
  def self.split_pane(session_name, vertical: true)
    direction_flag = vertical ? '-h' : '-v'
    system("tmux split-window -d #{direction_flag} -t #{session_name}")
  end

  # Select a specific pane in a tmux session
  def self.select_pane(session_name, pane_id)
    system("tmux select-pane -t #{session_name}.#{pane_id}")
  end

  # End a pane in a tmux session
  def self.end_pane(session_name, pane_id)
    system("tmux kill-pane -t #{session_name}.#{pane_id}")
  end

  def self.set_global_env(variable_name, value)
    system("tmux set-environment -g #{variable_name} '#{value}'")
  end

  # Get global environment variables from tmux
  # Returns all variables if no name is provided, otherwise returns the value of the named variable
  def self.get_global_env(variable_name = nil)
    output, status = Open3.capture2("tmux show-environment -g #{variable_name}")
    return {} unless status.success?

    if variable_name
      # Return just the value of the named variable
      return output.split('=', 2).last.strip
    else
      # Parse and return all variables as a hash
      env_vars = {}
      output.each_line do |line|
        key, value = line.strip.split('=', 2)
        env_vars[key] = value
      end
      return env_vars
    end
  end
  
end

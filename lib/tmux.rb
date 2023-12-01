require 'open3'
require 'pry'

class TmuxSession
  @@sessions = []
  @@count = 0

  attr_reader :name, :windows, :id

  def initialize(name, id)
    @name = name
    @id = id
    @windows = []
    @windows << TmuxWindow.new(self, @windows.count)
    @@count += 1
    @@sessions << self
  end

  def new_window
    @windows << TmuxWindow.new(self, @windows.count)
  end

  def end
    TmuxSession.destroy(self)
    TmuxSession.end_session(name)
  end

  def attach
    TmuxSession.attach_session(@name)
  end

  def first
    @windows.first.panes.first
  end

  def self.list
    @@sessions
  end

  def self.load_from_name(name)
    tmux_session = TmuxSession.list_sessions.select{|s| s[:id] == name}.first
    raise "no Tmux session #{name} found in listing" unless tmux_session and !tmux_session.nil?
    TmuxSession.new(name, @@count)
  end

  def self.create(name)
    session = TmuxSession.new(name, @@count)
    create_detached_session(session.name)
    session
  end

  def self.destroy(session)
    @@sessions = @@sessions.reject{|x| x.name == session.name}
    session.windows.each{|window| window.destroy }
    @@windows = nil
  end

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
    info.split("\n").map{|x| {id:x.split(" ")[0].delete(":")}}
  end

  # Create a new tmux session

  def self.create_detached_session(session_name)
    self.create_session(session_name, true)
  end

  #todo: consolidate logic of system command execution
  #use open3
  def self.create_session(session_name, detached = true)
    command = "tmux new-session" 
    command += " -d" if detached
    command += " -s #{session_name}"
    system(command)
    session_name
  end 

  def self.attach_session(session_name)
    system("tmux attach-session -t #{session_name}")
  end

  def self.end_session(session_name) 
    system("tmux kill-session -t #{session_name}")
  end 

  def self.set_global_env(variable_name, value)
    system("tmux set-environment -g #{variable_name} '#{value}'")
  end

  def self.set_session_env(session_id, variable_name, value)
    system("tmux set-environment -t #{session_name} #{variable_name} '#{value}'")
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

class TmuxWindow

  attr_reader :id, :session, :panes
  def initialize(session, id)
    @session = session
    @id = id
    @panes = [TmuxPane.new(self, 0)]
  end

  def target_id
    "#{@session.name}:#{@id}"
  end

  def new_pane
    @panes << TmuxPane.new(self, @panes.count)
    
  end

  def destroy
    @session = nil
    @panes.each{|pane| pane.destroy}
  end

  # Other window-specific methods...

  def split_v
    split(vertical:true)
  end

  def split_h
    split(vertical:false)
  end

  def split(vertical: true)
    # Logic to split a window
    TmuxWindow.split_by_target_id(target_id, vertical)
    new_pane
  end

  # Split a pane in a tmux session
  def self.split_by_target_id(target_id, vertical = true)
    direction_flag = vertical ? '-v' : '-h'
    system("tmux split-window -d #{direction_flag} -t #{target_id}")
  end

   #get a count of window panes
   def self.panes_count(window_id)
    #todo: parser formatting consolidation somewhere
    list_panes(window_id).first.split("\n").count
  end

   # List panes in a tmux session
   def self.list_panes_by_window_id(window_id)
    list_panes(window_id)
  end

  def self.list_panes(window_id = nil)
    command = "tmux list-panes"
    command += " -t #{window_id}" if window_id
    output, status = Open3.capture2(command)
    return nil unless status.success?

  end
  
end

class TmuxPane

  attr_reader :id, :window

  def initialize(window, id)
    @window = window
    @id = id
  end

  def target_id
    "#{@window.target_id}.#{@id}"
  end

  def select
    TmuxPane.select_pane_by_target_id(target_id)
  end

  def end
    TmuxPane.end_pane_by_target_id(target_id)
  end

  def send_keys(keys)
    TmuxPane.send_keys_to_pane(target_id, keys)
  end

  def send_command(command)
    TmuxPane.send_command_to_pane(target_id, command)
  end

  def destroy
    @window = nil
  end

  # Send a command to a tmux pane
  def self.send_command_to_pane(target_id, command)
    system("tmux send-keys -t #{target_id} \"#{command}\" C-m")
  end

   # Send a keys to a tmux pane
   def self.send_keys_to_pane(target_id, input)
    system("tmux send-keys -t #{target_id} '#{input}'")
   end

  # Capture the output from a tmux pane
  def self.capture_output(target_id, pane_id = 0)
    output, status = Open3.capture2("tmux capture-pane -pt #{session_name}:#{pane_id}")
    status.success? ? output : nil
  end

  # Select a specific pane in a tmux session
  def self.select_pane_by_target_id(target_id)
    system("tmux select-pane -t #{target_id}")
  end

  # End a pane in a tmux session
  def self.end_pane_by_target_id(session_name, pane_id)
    system("tmux kill-pane -t #{target_id}")
  end

 
end
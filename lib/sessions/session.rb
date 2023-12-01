require_relative 'tmux'

class Session

  @@data_dir = '../../data/sessions'
  attr_reader :name,:context,:tmux_session

  def initialize(name, tmux_session_name)
    @name = name
    @started_at = Time.now.to_i
    @tmux_session = TmuxSession.load_from_name(tmux_session_name)
    @data_dir = @@data_dir + "/#{@name}/#{@started_at}"
    @context = []

  end

  def send_keys_to_control_pane(keys)
    @tmux_session.windows.first.panes.select{|p| p.id == 0}.first.send_keys(keys)
  end

  def send_command_to_control_pane(command)
    @tmux_session.windows.first.panes.select{|p| p.id == 0}.first.send_command(command)
  end

  def add_hooks
    Pry.hooks.add_hook(:before_session, 'noprompt') do |output, binding, pry_instance|
      pry_instance.prompt = Pry::Prompt.new('empty', 'No visible prompt', [proc { '' }, proc { '' }])
    end

    Pry.hooks.add_hook(:before_session, 'helper_intro') do |output, binding, pry_instance|
    system("clear")
    pry_instance.prompt = Pry::Prompt.new('empty', 'No visible prompt', [proc { '' }, proc { '' }])
    puts "\n\nH E L P E R   \n
    \n
    How can I help you?"
          
    end
  end

end
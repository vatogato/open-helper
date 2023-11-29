
class Session
  attr_reader :name,:type

  def initialize(name,tmux_session, type)
    @name = name
    @type = type
    @started_at = Time.now.to_i
    @tmux_session = tmux_session

  end

  def send_keys_to_control_pane(keys)
    @tmux_session.windows.first.panes.select{|p| p.id == 0}.first.send_keys(keys)
  end

  def send_command_to_control_pane(command)
    @tmux_session.windows.first.panes.select{|p| p.id == 0}.first.send_command(command)
  end

  def get_binding
    binding
  end

  # TODO: proper class encapsulation or something whatever
end
require_relative '../tmux'
require 'pry'



class Session

  attr_reader :name,:context,:tmux_session

  def initialize(name, tmux_session_name)
    @name = name
    #need to find or create here in case I tihnk for non duplicated something or other maybe
    @tmux_session = TmuxSession.load_from_name(tmux_session_name)
    @context = []

  end

  def self.available_sessions
    Dir.glob("*").reject{|session| session == "session.rb"}
  end

  def send_keys_to_pane(keys, id)
    @tmux_session.windows.first.panes.select{|p| p.id == id}.first.send_keys(keys)
  end

  def send_command_to_pane(command, id)
    @tmux_session.windows.first.panes.select{|p| p.id == id}.first.send_command(command)
  end

  

  def add_pry_hooks
    Pry.hooks.add_hook(:before_session, 'noprompt') do |output, binding, pry_instance|
      pry_instance.prompt = Pry::Prompt.new('empty', 'No visible prompt', [proc { '' }, proc { '' }])
    end

    Pry.hooks.add_hook(:before_session, 'helper_intro') do |output, binding, pry_instance|
      system("clear")
      pry_instance.prompt = Pry::Prompt.new('empty', 'No visible prompt', [proc { '' }, proc { '' }])
      puts "\n\nH E L P E R\n\nOptions:\n\n" 
      Session.available_sessions.each_with_index do |session_type, index|
        puts "#{index+1}: Start #{session_type}"
      end
    end
  end

  def start
    add_pry_hooks
    binding.pry
  end

end

if ARGV[0] && ARGV[0] == "pry"
  Session.new("helper", ARGV[1]).start
end
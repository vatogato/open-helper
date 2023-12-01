
require 'pry'  
require_relative 'lib/active/tmux'  # This line loads the Tmux module
# require_relative 'lib/active/prompt'  # This line loads the Tmux module
# require_relative 'lib/active/conversation' 
require_relative 'lib/active/pry_helper'
require_relative 'lib/active/pryllama_session'
#todo: better loading of necessary ruby files

#step = ARGV[1]

#todo:  make a Helper class/module with setup functionality
#different scripts for tmux setup and pry


name = ARGV[0]


tmux_session = TmuxSession.create(name)
#todo: proper config constants for things like HELPER_COMMAND

pane = tmux_session.windows.first.panes.first

commands = ENV.select{|key,value| key.include? "HELPER_COMMAND"}

#sort by number in env var key
commands = commands.sort_by{|k,v| k.split("_").last}

if commands.nil? || commands.empty?
  puts "You didn't specify any commands. set ENV vars for HELPER_COMMAND_X (x = 1,2,3, etc)"
  exit 1
end

#for each command, issueto first tmux pane

commands.each do |key,command|
    puts "in commands loop"
    pane.send_command(command)
end

# pane.send_command('pry')
# pane.send_command('PryLlamaSession.new(' + name + ').start')

#need to attach at the last section
# for a bit of magic to get this setup in a running
#Tmux session from within Ruby.  I refused to make a bash script around this.
#refused, I say.  Whether or not this was a good idea, time will tell, but good and bad
# are mostly subjective anyway, so whatever.

tmux_session.attach



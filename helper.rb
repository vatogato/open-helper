
require 'pry'  
require 'open3'
require_relative 'library'
require_relative 'globals'
#todo: better loading of necessary ruby files

#step = ARGV[1]

#todo:  make a Helper class/module with setup functionality
#different scripts for tmux setup and pry


step = ARGV[0]
name = ARGV[1]


#todo: proper config constants for things like HELPER_COMMAND
if step == "setup"
    git_command = "git add .; git commit -m 'checking out new helper session';" + "git checkout -B session_#{name}_#{Time.now.to_i}"

    Open3.capture2(git_command)

    Open3.capture2("cd #{LIB_DIR}/sessions")


    tmux_session = TmuxSession.create(name, detached:false, script:"ruby helper.rb #{name} start")

elsif step == "start"

Open3.capture2("ruby session.rb pry #{name}")

    #need to attach at the last section
    # for a bit of magic to get this setup in a running
    #Tmux session from within Ruby.  I refused to make a bash script around this.
    #refused, I say.  Whether or not this was a good idea, time will tell, but good and bad
    # are mostly subjective anyway, so whatever.

end



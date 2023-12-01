
require 'pry'  
require 'open3'
require_relative 'library'
require_relative 'globals'
#todo: better loading of necessary ruby files

#step = ARGV[1]

#todo:  make a Helper class/module with setup functionality
#different scripts for tmux setup and pry


name = ARGV[0]


#todo: proper config constants for things like HELPER_COMMAND
    puts "saving and creating new branch"
    git_command = "git add .; git commit -m 'checking out new helper session';" + "git checkout -B session_#{name}_#{Time.now.to_i}"

    Open3.capture2(git_command)

    puts "creating tmux session"
    tmux_session = TmuxSession.create(name, detached:true,script:'')

    puts "changing directory to sessions"
    
    Dir.chdir("#{LIB_DIR}/sessions")

    system("ruby session.rb pry #{name}")

    #need to attach at the last section
    # for a bit of magic to get this setup in a running
    #Tmux session from within Ruby.  I refused to make a bash script around this.
    #refused, I say.  Whether or not this was a good idea, time will tell, but good and bad
    # are mostly subjective anyway, so whatever.




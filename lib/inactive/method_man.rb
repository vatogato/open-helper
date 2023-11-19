# New module to encapsulate in session methods being defined
# can move them to proper places once we confirm functionality
# during a pry session with the LLM

module MethodMan#ager
               
  
  def self.activate_iterm2
    system("osascript -e 'tell application \"iTerm\" to activate'")
  end


  def self.start_tmux_session_in_iterm(session_name)
    apple_script = <<-APPLESCRIPT
      tell application "iTerm"
        set newWindow to (create window with HelperMain profile)
        tell current session of newWindow
          write text "tmux new-session -s #{session_name}"
        end tell
      end tell
    APPLESCRIPT
    
    system("osascript -e '#{apple_script}'")
  end

  #method to define a method within the MethodMan module
  # i need to learn how to save the session state of the class and
  # have it compiled to replace the old code.
  # either this or run a second session that uses a staging branch
  # of open-helper with the suggested change to verify.
  # have it talk to itss self.
  def self.define_method(code)

  end

  #return a list of all methods currently defined in the Module
  # i think you can find this with just Pry inspection somehow
  def self.find_module_methods
  
  end
  
end

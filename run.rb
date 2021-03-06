#!/usr/bin/env ruby
#===========================================================================================================
# Additional tutorials and usefull information.
#   https://github.com/vaiorabbit/ruby-opengl
#   http://larskanis.github.io/opengl/tutorial.html
#===========================================================================================================
puts "\n" * 3 # some top buffer for terminal notifications.
puts "*" * 70
#---------------------------------------------------------------------------------------------------------
# https://www.codecademy.com/articles/ruby-command-line-argv
APP_NAME = 'Desktop Garage'
ARGV.each do |launch_arg|
  case launch_arg
  when '--debug'
    puts "#{APP_NAME} is in debug mode."
  end
end
#---------------------------------------------------------------------------------------------------------
ROOT = File.expand_path('.',__dir__)
puts "starting up..."
# Gem used for OS window management and display libs as well as User input call backs.
require 'gosu'    # https://rubygems.org/gems/gosu
#---------------------------------------------------------------------------------------------------------
# OpenGL pre-requiries.
require 'opengl'  # https://rubygems.org/gems/opengl-bindings
require 'glu'
OpenGL.load_lib
GLU.load_lib
include OpenGL, GLU
#---------------------------------------------------------------------------------------------------------
# System wide vairable settings.
require "#{ROOT}/Konfigure.rb"
include Konfigure # inclusion of CONSTANT settings system wide.

#===========================================================================================================
# Load all additional source scripts. Files need to be in directory ALPHABETICAL order if refrenced in a later object source file.
script_dir = File.join(ROOT, "AdditionalClasses")
if FileTest.directory?(script_dir)
  # map to hash parrent directory, !ALPHABETICAL loading order!
  files = [script_dir].map do |path|
    if File.directory?(path)
      Dir[File.join(path, '**', '*.rb')] # grab EVERY .rb file in provided directory.
    else # dir to file
      path
    end
  end.flatten
  # require all located source file_dirs, if you dont want to use ALPHABETICAL order,
  # then make your changes here...
  files.each do |source_file|
    begin # load error net
      require(source_file)
    rescue => error # catch syntax errors on a file basis
      temp = source_file.split('/').last
      puts("FO Error: loading dir (#{temp})\n#{error}")
    end
  end
end

#===========================================================================================================
# after ensuring all data is loaded, require the map class object.
require "#{ROOT}/EditorState.rb"


#===========================================================================================================
# Gosu display window for the game.
#===========================================================================================================
class Program < Gosu::Window
  include QuickControls
  @@active_state = nil  # The current update loop task to take care of, generaly closed state object loops.
  attr_accessor :show_system_mouse
  #---------------------------------------------------------------------------------------------------------
  #D: Create the Klass object.
  #---------------------------------------------------------------------------------------------------------
  def initialize
    super(RESOLUTION[0], RESOLUTION[1], {:update_interval => UP_MS_DRAW, :fullscreen => ISFULLSCREEN})
    @show_system_mouse = false
    $program = self   # global pointer to window creation object
    controls_init     # prep the input controls scheme manager
    @@active_state = EditorState.new()
  end
  #---------------------------------------------------------------------------------------------------------
  def active_state
    return @@active_state
  end
  #---------------------------------------------------------------------------------------------------------
  #D: https://www.rubydoc.info/github/gosu/gosu/master/Gosu/Window#needs_cursor%3F-instance_method
  #---------------------------------------------------------------------------------------------------------
  def needs_cursor?
    return @show_system_mouse
  end
  #---------------------------------------------------------------------------------------------------------
  def update
    input_update # updates the backend control scheme manager
    #--------------------------------------
    super # empty caller
    @@active_state.update unless @@active_state.nil?
  end
  #---------------------------------------------------------------------------------------------------------
  def draw
    # 3D objects ontop of the Gosu draws are called here...
    # you can perform Gosu.draw functions out side of ' gl ' blocks.
    #---------------------------------------------------------
    # !DO NOT MIX GOSU DRAW AND OPENGL DRAW CALLS!
    gl do
      #---------------------------------------------------------
      # this maintains only one gl do block which prevents errors.
      # the class it forwords the gl draw call to should incorperate
      # a means of the 3D perspective threw a camera object or such.
      unless @@active_state.nil?
        @@active_state.gl_draw
      end
      #---------------------------------------------------------
    end
    # !DO NOT MIX GOSU DRAW AND OPENGL DRAW CALLS!
    #---------------------------------------------------------
    # Do not use gosu.draw while inside a gl operation function call! use them before or after blocks.
    # Gosu draws ontop of the 3D objects are called here...
    @@active_state.draw unless @@active_state.nil?
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called when the window in the OS is closed threw the system interfaces.
  #D: https://www.rubydoc.info/github/gosu/gosu/Gosu%2FWindow:close 
  #---------------------------------------------------------------------------------------------------------
  def close
    @@active_state.destroy unless @@active_state.nil?
    super
    self.close!
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called when a key is depressed. ID can be an integer or an array of integers that reference input symbols.
  #---------------------------------------------------------------------------------------------------------
  def button_down(id)
    super(id)
    unless @buttons_down.include?(id)
      @input_lag = INPUT_LAG
      @buttons_down << id
    end
    #return unless PRINT_INPUT_KEY
    #print("Buttons currently held down: #{@buttons_down} T:#{@triggered}\n")
    #print("Window button pressed: (#{id}) which is (#{self.get_input_symbol(id).to_s})\n")
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called when a button was held but was released. ID can be an integer or an array of integers that 
  #D: reference input symbols.
  #---------------------------------------------------------------------------------------------------------
  def button_up(id)
    super(id)
    @buttons_up << id unless @buttons_up.include?(id)
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Return a Gosu::Font class, short hand.
  #---------------------------------------------------------------------------------------------------------
  def font(font_name, size)
    font_name = DEFAULT_FONT if font_name.nil?
    file = File.join(ROOT, "Media/Fonts", font_name)
    unless FileTest.exist?(file)
      puts "-" * 70
      puts "ProgramFont: Load error- ( #{font_name} ) \n#{caller[0]}"
      return nil
    end
    return Gosu::Font.new(self, file, size)
  end
end

#===========================================================================================================
display_window = Program.new
display_window.show_system_mouse = true
display_window.show # call and draw loop the Gosu::Window class object.
puts("Shutting down...")


#===========================================================================================================
# !!!   Editor.rb  |  Container object that keeps track of all mesh related things.
#---------------------------------------------------------------------------------------------------------
# Version 0.0
# Date: 0/0/0
#===========================================================================================================
class EditorState
  attr_reader :track
  attr_accessor :camera, :numberof_cameras
  #---------------------------------------------------------------------------------------------------------
  #D:  Create the Klass object.
  #---------------------------------------------------------------------------------------------------------
  def initialize(**options)
    @cameras = []
    @numberof_cameras = Konfigure::NUMBEROF_WINDOWS
    # create each player object
    @numberof_cameras.times do |index|
      @cameras << Camera.new({ :name => "Camera #{index}", :index => index, :StateContainer => self })
    end
    # post updates along build path to terminal
    puts("!All racers are Ready!")
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Follows threw with key pressed.
  #---------------------------------------------------------------------------------------------------------
  def look_for_input_key
    return if $program.nil?
    if $program.trigger?(:cancel_action)   # exit the program
      quit_program 
    elsif $program.trigger?(:mouse_lclick) # click events?
      #puts "click!"
    elsif $program.trigger?(:let_r)        # restart button
      #puts "start over!"
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Closes game window process.
  #---------------------------------------------------------------------------------------------------------
  def quit_program
    exit
    return true # return true for buttons.
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Update loop for all map realted objects in container.
  #---------------------------------------------------------------------------------------------------------
  def update
    look_for_input_key
    @cameras.each do |player| 
      player.update unless player.nil?
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw method hand along for all inter conponents related to the map display.
  #---------------------------------------------------------------------------------------------------------
  def draw
    @cameras.each do |player| 
      player.draw unless player.nil?
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: OpenGL draw method hand along for all inter conponents related to the map display.
  #---------------------------------------------------------------------------------------------------------
  def gl_draw
    @cameras.each do |player| 
      player.gl_draw unless player.nil?
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called on state change, speeds up the GC responce.
  #---------------------------------------------------------------------------------------------------------
  def destroy
    @cameras.each do |player| 
      player.destroy unless player.nil?
    end
  end
end



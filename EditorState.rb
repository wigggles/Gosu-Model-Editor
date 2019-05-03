#===========================================================================================================
# !!!   Editor.rb  |  Container object that keeps track of all mesh related things.
#---------------------------------------------------------------------------------------------------------
# Version 0.0
# Date: 0/0/0
#===========================================================================================================
class EditorState
  attr_reader :track
  attr_accessor :camera, :numberof_workboxes
  #---------------------------------------------------------------------------------------------------------
  #D:  Create the Klass object.
  #---------------------------------------------------------------------------------------------------------
  def initialize(**options)
    @workboxes = []
    @numberof_workboxes = Konfigure::NUMBEROF_BOXES
    @numberof_workboxes.times do |index|
      @workboxes << WorkBox.new({ :name => "WorkBox: #{index}", :index => index, :StateContainer => self })
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Follows threw with key pressed.
  #---------------------------------------------------------------------------------------------------------
  def look_for_input_key
    return if $program.nil?
    if $program.trigger?(:cancel_action)   # exit the program
      quit_program 
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Update loop for all map realted objects in container.
  #---------------------------------------------------------------------------------------------------------
  def update
    look_for_input_key
    @workboxes.each do |workbox| 
      workbox.update unless workbox.nil?
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw method hand along for all inter conponents related to the map display.
  #---------------------------------------------------------------------------------------------------------
  def draw
    @workboxes.each do |workbox| 
      workbox.draw unless workbox.nil?
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: OpenGL draw method hand along for all inter conponents related to the map display.
  #---------------------------------------------------------------------------------------------------------
  def gl_draw
    @workboxes.each do |workbox| 
      workbox.gl_draw unless workbox.nil?
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called on state change, speeds up the GC responce.
  #---------------------------------------------------------------------------------------------------------
  def destroy
    @workboxes.each do |workbox| 
      workbox.destroy unless workbox.nil?
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Closes game window process.
  #---------------------------------------------------------------------------------------------------------
  def quit_program
    exit
    return true # return true for called from buttons.
  end
end



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
      options = { :name => "WorkBox: #{index}", :index => index, :StateContainer => self }
      case index
      when 0 
        @workboxes << ModelBox.new(options)
      when 1
        @workboxes << ZPlaneBox.new(options)
      when 2
        @workboxes << XPlaneBox.new(options)
      when 3
        @workboxes << YPlaneBox.new(options)
      else # defualt
        @workboxes << WorkBox.new(options)
      end
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
    draw_mouseCursor # status updates?
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
  #---------------------------------------------------------------------------------------------------------
  #D: Draw mouse cursor onto screen at location of system mouse, but only if its not displaying the system one.
  #D: https://www.rubydoc.info/github/gosu/gosu/master/Gosu/Window#needs_cursor%3F-instance_method
  #---------------------------------------------------------------------------------------------------------
  def draw_mouseCursor
    # only draw if not using system cursor
    return if $program.needs_cursor? # setting is defined inside the Program class object, ( run.rb )
    # draw mouse cursor on mouse position
    $program.draw_rect($program.mouse_x - 3, $program.mouse_y - 3, 9, 9, 0xff_000000, 500)
    $program.draw_rect($program.mouse_x - 1, $program.mouse_y - 1, 5, 5, 0xff_f88fff, 501)
    # could also be an image file if desired:
    #@image = Image_Manager.load_image("Mouse_Cursor.png")
    #@image.draw($program.mouse_x, $program.mouse_y, 100000) unless @image.nil?
  end
end



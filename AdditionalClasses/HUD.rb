#===========================================================================================================
# !!!   HUD.rb  |  All the on screen information you would ever need.
#---------------------------------------------------------------------------------------------------------
# Version 0.0
# Date: 0/0/0
#===========================================================================================================
class HUD
  UPDATE_PAUSES = 3 # time between update calls for all display string information.
  attr_accessor :x, :y
  #---------------------------------------------------------------------------------------------------------
  #D: Create Klass object.
  #---------------------------------------------------------------------------------------------------------
  def initialize(**options)
    # out side pointers:
    @camera  = options[:Camera] || nil
    # interal stuff:
    @update_ticker = 0 # time between text string display updates.
    @font = $program.font(nil, 18)
    add_mouse_items
    add_text_boxes
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called to make changes to the slider values.
  #---------------------------------------------------------------------------------------------------------
  def update_slider_changes
    return if @interactables.nil?
    @interactables.each do |display_item, slider_object|
      next unless slider_object.changed?
      case display_item
      when :camera_zoom
        @camera.test_slider(slider_object.percentage)
      end
      slider_object.update_called
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: All the text display containers.
  #---------------------------------------------------------------------------------------------------------
  def add_text_boxes
    # create display text boxes
    @text_boxes = {}
    def_options = {:size => 18, :z => 10001}
    @text_displays = { # starting location of the text boxes:
      :test_text    => {:x => 10, :y => 8},
      :camera_name  => {:x => 10, :y => 40},
    }
    # make the empty string display boxes:
    @text_displays.each do |display_item, text_options|
      text_options[:text] = display_item.to_s
      text_options.merge!(def_options)
      text_options[:x] += @camera.screen_xpos
      text_options[:y] += @camera.screen_ypos
      @text_boxes[display_item] = Text_Box.new("", text_options)
    end
    # create the first cache of the data info to display
    update_text_strings
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Update what the current text being displayed should say.
  #---------------------------------------------------------------------------------------------------------
  def update_text_strings
    return if @text_boxes.nil? || @camera.nil?
    # Testing "Hello World"
    @text_boxes[:test_text].text    = "% #{@camera.slider_percentage.round(4)}"
    @text_boxes[:camera_name].text  = "#{@camera.name}"
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Create interactable sprite mouse items.
  #---------------------------------------------------------------------------------------------------------
  def add_mouse_items
    @interactables = {}
    # configure the defualt display settings:
    def_options = {
      # starting locaion for offsets performed later:
      :x => @camera.screen_xpos, :z => 10000,
      # bar is width x height of object: 
      :bar => [250, 10], :color => [0xFF_66089f, 0xFF_cc22ff],
      # :way is an integer for vertical is '0', horizontal is '1', 
      # :bar_scale is used for the size of the slider on creation.
      # the higher the scale the smaller the slider "bar" located on the slider "rail" is.
      :way => 1, :bar_scale => 10, :style => 1,
      # where to start the slider value off at?
      :start_point => :middle
    }
    # sprite screen placement and properties
    @slider_displays = { # starting location of interacatables:
      :camera_zoom   => {:y => 24}
    }
    # create all the refrenceable slider bars:
    @slider_displays.each do |display_item, display_options|
      display_options.merge!(def_options)
      display_options[:text] = display_item.to_s
      # move to screen owner position camera:
      display_options[:y] += @camera.screen_ypos
      # create the object
      @interactables[display_item] = Sprite_Scroll_Bar.new(display_options)
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Gosu::Window.tick looping method call threw.
  #---------------------------------------------------------------------------------------------------------
  def update
    return if @interactables.nil? || @text_boxes.nil?
    if @update_ticker <= 0
      update_text_strings
      update_slider_changes
      @update_ticker = UPDATE_PAUSES
    else
      @update_ticker -= 1
    end
    return if @camera.nil?
    @interactables.each_value do |sprite|
      sprite.update unless sprite.nil?
    end
    # text display effects?
    @text_boxes.each_value do |text| 
      text.update unless text.nil?
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw all the sprite and image realted information to the screen.
  #---------------------------------------------------------------------------------------------------------
  def draw
    draw_mouseCursor if @camera.index < 1
    return if @interactables.nil? || @text_boxes.nil?
    #---------------------------------------------------------
    @interactables.each_value do |sprite|
      sprite.draw unless sprite.nil?
    end
    #---------------------------------------------------------
    @text_boxes.each_value do |text|
      text.draw unless text.nil?
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called on state change, helps the GC release object space.
  #---------------------------------------------------------------------------------------------------------
  def destroy
    @interactables.each_value do |sprite|
      sprite.destroy unless sprite.nil?
    end
    @interactables = nil
    #---------------------------------------------------------
    @text_boxes.each_value do |text|
      text.destroy unless text.nil?
    end
    @text_boxes = nil
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
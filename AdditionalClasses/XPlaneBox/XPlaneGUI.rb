#===========================================================================================================
# !!!   XPlaneGUI.rb  |  Things to interact with the model on the X plane.
#===========================================================================================================
class XPlaneGUI < HUD
  attr_accessor :x, :y
  #---------------------------------------------------------------------------------------------------------
  #D: Create Klass object.
  #---------------------------------------------------------------------------------------------------------
  def initialize(**options)
    @font_size = 18
    super(options)
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Create the objects to interact with inside the hud.
  #---------------------------------------------------------------------------------------------------------
  def create_objects
    @text_displays = { # starting location of the text boxes:
      :test_text    => {:x => 10, :y => 8},
      :camera_name  => {:x => 10, :y => 40},
    }
    # sprite screen placement and properties
    @slider_displays = { # starting location of interacatables:
      :camera_zoom   => {:y => 24}
    }
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
end
#===========================================================================================================
# !!!   HUD.rb  |  All the on screen information you would ever need.
#===========================================================================================================
class HUD
  UPDATE_PAUSES = 3 # time between update calls for all display string information.
  attr_accessor :x, :y
  #---------------------------------------------------------------------------------------------------------
  #D: Create Klass object.
  #---------------------------------------------------------------------------------------------------------
  def initialize(**options)
    create_objects
    # out side pointers:
    @boxowner  = options[:BoxOwner] || nil
    # interal stuff:
    @update_ticker = 0 # time between text string display updates.
    @font = $program.font(nil, 18)
    add_mouse_items
    add_text_boxes
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called as a fail safe if there wasn't a call on child class.
  #---------------------------------------------------------------------------------------------------------
  def create_objects
    @text_displays = {}
    @slider_displays = {}
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called to make changes to the slider values.
  #---------------------------------------------------------------------------------------------------------
  def update_slider_changes
    
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Update what the current text being displayed should say.
  #---------------------------------------------------------------------------------------------------------
  def update_text_strings
    
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Create interactable sprite mouse items.
  #---------------------------------------------------------------------------------------------------------
  def add_mouse_items
    
  end
  #---------------------------------------------------------------------------------------------------------
  #D: All the text display containers.
  #---------------------------------------------------------------------------------------------------------
  def add_text_boxes
    # create display text boxes
    @text_boxes = {}
    def_options = {:size => @font_size, :z => 10001}
    # make the empty string display boxes:
    @text_displays.each do |display_item, text_options|
      text_options[:text] = display_item.to_s
      text_options.merge!(def_options)
      text_options[:x] += @boxowner.screen_xpos
      text_options[:y] += @boxowner.screen_ypos
      @text_boxes[display_item] = Text_Box.new("", text_options)
    end
    # create the first cache of the data info to display
    update_text_strings
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
    return if @boxowner.nil?
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
    unless @interactables.nil?
      @interactables.each_value do |sprite|
        sprite.destroy unless sprite.nil?
      end
      @interactables = nil
    end
    #---------------------------------------------------------
    unless @text_boxes.nil?
      @text_boxes.each_value do |text|
        text.destroy unless text.nil?
      end
      @text_boxes = nil
    end
  end
end
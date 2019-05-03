#===========================================================================================================
# !!!   WorkBox.rb  |  Things are contained to their seperate boxes when doing tasks.
#===========================================================================================================
class WorkBox
  @@active_state = nil
  attr_reader :index, :slider_percentage, :name
  #---------------------------------------------------------------------------------------------------------
  #D: Create Klass object.
  #---------------------------------------------------------------------------------------------------------
  def initialize(**options)
    @index = options[:index] || 0
    if @@active_state.nil?
      @@active_state = options[:StateContainer]
    end
    @name = options[:name] || "Defualt"
    # set offset location:
    case index
    when 0 # TR
      @x = 0
      @y = 0
      @bg_c = 0xFF_158835
    when 1 # TL
      @x = screen_width
      @y = 0
      @bg_c = 0xFF_156ff4
    when 2 # BR
      @x = 0
      @y = screen_height
      @bg_c = 0xFF_d4124f
    else   # BL
      @x = screen_width
      @y = screen_height
      @bg_c = 0xFF_5a6f53
    end
    # for testing:
    @slider_percentage = 0.0
  end
  #---------------------------------------------------------------------------------------------------------
  def self.active_state
    return @@active_state
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Changes called to from the outside.
  #---------------------------------------------------------------------------------------------------------
  def test_slider(percentage)
    @slider_percentage = percentage
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Screen related effects to display to reflect player interaction with map/entities.
  #---------------------------------------------------------------------------------------------------------
  def update
    if @hud.nil?
      @hud = HUD.new({ :BoxOwner => self })
    else
      @hud.update
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw any 2D sprite images to the screen that represent player status or information.
  #---------------------------------------------------------------------------------------------------------
  def draw
    # HUD things
    @hud.draw unless @hud.nil?
    # https://www.rubydoc.info/github/gosu/gosu/master/Gosu#translate-class_method
    Gosu.translate(self.screen_xpos, self.screen_ypos) do
      # https://www.rubydoc.info/github/gosu/gosu/master/Gosu#clip_to-class_method
      Gosu.clip_to(0, 0, self.screen_width, self.screen_height) do

        # draw only with in the designated editor window.
        # keeps up with gosu image by use of caching:
        # image = (Image_Manager.load_image(options) == Gosu::Image.new) load only once...
        $program.draw_rect(0, 0, self.screen_width, self.screen_height, @bg_c, 0)


      end
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw any 3D realted objects in the OpenGL draw loop.
  #---------------------------------------------------------------------------------------------------------
  def gl_draw

    # how to limit like with draw?
    
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Used to offset all X internal screen drawing for the attached tracking object.
  #---------------------------------------------------------------------------------------------------------
  def screen_xpos
    return @x
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Used to offset all Y internal screen drawing for the attached tracking object.
  #---------------------------------------------------------------------------------------------------------
  def screen_ypos
    return @y
  end
  #---------------------------------------------------------------------------------------------------------
  #D: This is used for multiplayer.
  #---------------------------------------------------------------------------------------------------------
  def screen_width
    if Konfigure::NUMBEROF_BOXES > 2
      return $program.width / 2
    else
      return $program.width
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: This is used for multiplayer.
  #---------------------------------------------------------------------------------------------------------
  def screen_height
    if Konfigure::NUMBEROF_BOXES > 1
      return $program.height / 2
    else
      return $program.height
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called on object removal, helps GC a bit.
  #---------------------------------------------------------------------------------------------------------
  def destroy
    @hud.destroy unless @hud.nil?
  end
end
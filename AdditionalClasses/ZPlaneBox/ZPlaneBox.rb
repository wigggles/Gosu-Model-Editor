#===========================================================================================================
# !!!   ZPlaneBox.rb  |  The model from its Z plane.
#===========================================================================================================
class ZPlaneBox < WorkBox
  #---------------------------------------------------------------------------------------------------------
  #D: Create Klass object.
  #---------------------------------------------------------------------------------------------------------
  def initialize(**options)
    super(options)
    @name = "Z Plane Editor"
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
      @hud = ZPlaneGUI.new({ :Camera => self })
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
end
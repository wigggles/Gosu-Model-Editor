#===============================================================================================================================
# !!!   Sprite_TextBox.rb  |  Used for GUI text displays.
#-----------------------------------------------------------------------------------------------------------------------------
# Version 0.5
# Date: 2/20/19
#===============================================================================================================================
# Defualt font file to load from `Media\fonts`
include Konfigure
#---------------------------------------------------------------------------------------------------------
class Text_Box < BareObject
#K------------------------------------------------------------------------------------------------------------------------------
# Draws text onto the screen using:  https://www.rubydoc.info/github/gosu/gosu/Gosu/Font
# Is a self contained GUI object used in a Curtain or Stage class where displaying text is needed.
#K------------------------------------------------------------------------------------------------------------------------------
  #D: Create klass instance, instance options are {:color, :font, :zorder, :x, :y}
  #---------------------------------------------------------------------------------------------------------
  def initialize(string = "", options = {})
    super(options)
    @effects    = [Gosu::Color.new(0xFF_000000), 0, 0, 0] #DV Container shared for effect drawing.
    @effect     = options[:effect]|| nil          #DV Effect type used when displaying the text box.
    @z          = options[:z]     || 100          #DV Screen Z layer Gosu.draw setting.
    @color      = options[:color] || 0xFF_FFFFFF  #DV Color used for text string draw.
    @font_size  = options[:size]  || 32           #DV Size to draw the text string at.
    @alignment  = options[:align] || :left        #DV Display alignent for the string. [:left, :center, :right]
    @draw_error = false                           #DV There was an error displaying text, tigger info on that issue.
    font_name = options[:font]  || nil # will use defualt if text name is nil.
    @font = $program.font(font_name, @font_size) #DV Font currently used for text image creation, is a Gosu::Font
    self.text = string # set display string @text
    @y -= @font_size / 2 #DV Screen Y pos for displaying text, on initialize @y is offset by half of the Font display size.
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Change the color used for display.
  #---------------------------------------------------------------------------------------------------------
  def color=(value)
    # https://www.rubydoc.info/github/gosu/gosu/master/Gosu/Color
    unless value.is_a?(Gosu::Color)
      value = Gosu::Color.new(value)
    end
    @color = value
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Change nested alpha value used in draw color. https://www.rubydoc.info/github/gosu/gosu/Gosu/Color
  #---------------------------------------------------------------------------------------------------------
  def alpha=(value)
    unless @color.is_a?(Gosu::Color)
      @color = Gosu::Color.new(@color)
    end
    @color.alpha = value
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Return the pixel width of text being displayed with current font.
  #---------------------------------------------------------------------------------------------------------
  def width
    # https://www.rubydoc.info/github/gosu/gosu/Gosu/Font#text_width-instance_method
    return @text.length * @font_size #@font.text_width(@text)
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Animated display style changes and such can be done in this function.
  #---------------------------------------------------------------------------------------------------------
  def update
    return if self.destroyed?
    super
    return if @effect.nil?
    case @effect
    when 'rainbow'
      @effects[1] = @effects[1] + 1 % 255
      @effects[2] = @effects[2] + 1 % 255
      @effects[3] = @effects[3] + 1 % 255
      @effects[0] = Gosu::Color.argb(255, @effects[1], @effects[2], @effects[3])
    else
      # normal text
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Return the current alpha value.
  #---------------------------------------------------------------------------------------------------------
  def alpha
    unless @color.is_a?(Gosu::Color)
      @color = Gosu::Color.new(@color)
    end
    return @color.alpha
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Change the display text image.
  #---------------------------------------------------------------------------------------------------------
  def text=(value)
    @text = value
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Speed up GC flagging.
  #---------------------------------------------------------------------------------------------------------
  def destroy
    @text  = nil
    @font  = nil
    super
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Per draw based display effects.
  #---------------------------------------------------------------------------------------------------------
  def display_effect
    case @effect
    when 'rainbow'
      @font.draw_text(@text, @x, @y, @z, 1, 1, @effects[0])
    else # normal
      @font.draw_text(@text, @x, @y, @z, 1, 1, @color)
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw the text string with the font to the screen.
  #---------------------------------------------------------------------------------------------------------
  def draw(x = nil, y = nil, z = nil, fx = nil, fy = nil)
    return if self.destroyed?
    @x = x unless x.nil?
    @y = y unless y.nil?
    @z = z unless z.nil?
    unless @effect.nil? # active string
      display_effect
    else # alternative cached drawing, static string
      #@image.draw(@x, @y, @z) unless @image.nil? # doesnt want to work?
      case @alignment
      when :center 
        @font.draw_text(@text, @x - (width / 2), @y, @z, 1, 1, @color)
      when :right  
        @font.draw_text(@text, @x - width, @y, @z, 1, 1, @color)
      else # defualts to :left
        @font.draw_text(@text, @x, @y, @z, 1, 1, @color)
      end
      #puts "#{@image} Text Box: #{@x}, #{@y}, #{@z}, #{@text}"
    end
  end
end
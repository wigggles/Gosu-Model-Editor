#===============================================================================================================================
# !!!  Sprite_Scroll_Bar.rb |  Quick creation of window index scroll bars.
#-----------------------------------------------------------------------------------------------------------------------------
# Version 0.5
# Date: 2/20/19
#===============================================================================================================================
class Sprite_Scroll_Bar < BareObject
#K------------------------------------------------------------------------------------------------------------------------------
# An easy way to create mouse interactive sprite item inside of game windows.
#K------------------------------------------------------------------------------------------------------------------------------
  MAX = 1000 # Value used to define the top of the bar, a higher value means more scrolling accuracy.
  #---------------------------------------------------------------------------------------------------------
  #D: Create Klass insistence. 
  #---------------------------------------------------------------------------------------------------------
  def initialize(options = {})
    super()
    @x  = options[:x] || 0 #DV Screen X location.
    @y  = options[:y] || 0 #DV Screen Y location.
    @z  = options[:z] || 0 #DV Drawing order.
    #--------------------------------------
    color   = options[:color] || [0xffff00ff, 0xffccffff]
    @color  = color[0] #DV Red, Green, Blue, Alpha (00, 00, 00, 00) (ff, ff, ff, ff)
    @hcolor = color[1] #DV Mouse over box hover color.
    #--------------------------------------
    @bar_scale = options[:bar_scale] || 8 #DV Size of the bar compaired to distance of bar.
    @style     = options[:style] || 0 #DV Does the bar have special draw patterns?
    @direction = options[:way] || 0 #DV 0 = vertical, 1 = horizontal (cell labels)
    bar = options[:bar]
    if bar.nil? # build the rect to construct the bar object
      if @direction == 0
        bar = [10, 200]
      else
        bar = [200, 10]
      end
    end
    @width  = bar[0] #DV Length of slider bar.
    @height = bar[1] #DV Height of slider bar.
    #--------------------------------------
    @bar_value = 0 #DV Set sensitivity of bar with higher numbers.
    @start_point = options[:start_point] || nil
    unless @start_point.nil? 
      case @start_point
      when :center, :middle
        @bar_value = MAX / 2
      when :right, :full, :top
        @bar_value = MAX
      when :left, :empty, :bottom
        @bar_value = 0 # basically defualt
      end
    end
    #--------------------------------------
    @active = false #DV Prevent interaction with the bar till it is proper to do so.
    @changed = false
  end
  #---------------------------------------------------------------------------------------------------------
  def update_called
    @changed = false
  end
  #---------------------------------------------------------------------------------------------------------
  def changed?
    return @changed
  end
  #---------------------------------------------------------------------------------------------------------
  #D: 
  #---------------------------------------------------------------------------------------------------------
  def percentage
    return (@bar_value / MAX.to_f).to_f
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Update bar properties and input actions.
  #---------------------------------------------------------------------------------------------------------
  def update
    super
    if $program.holding?(:mouse_lclick)
      action
    else # disable the bar location update unless holding the input action that dictates it.
      @active = false
    end
    return @bar_value
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Size of the bar, its the sprite length based on either @width or @height depending on the bars orientation.
  #---------------------------------------------------------------------------------------------------------
  def bar_size
    if @direction == 0 
      return (@height / @bar_scale)
    else
      return (@width / @bar_scale)
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: It moves the location of the center bar to best match its location in the screen index shown.
  #---------------------------------------------------------------------------------------------------------
  def move_bar(val)
    @bar_value += val
    @bar_value = MAX if @bar_value > MAX
    @bar_value = 0 if  @bar_value < 0
  end
  #---------------------------------------------------------------------------------------------------------
  #D: This function is called on when there is an input interaction with the scroll bar.
  #---------------------------------------------------------------------------------------------------------
  def action
    m_x = $program.mouse_x
    m_y = $program.mouse_y
    off_set = bar_size / 2 # make the bar not jump to top of mouse click but centers it
    #---------------------------------------------------------
    # check orintation
    if @direction == 0   # vertical
      pos_x = @x
      pos_y = @y + ((@height - bar_size) * (@bar_value.to_f / MAX.to_f))
      over_slider = (m_x > pos_x && m_x < pos_x + @width && m_y > pos_y && m_y < pos_y + bar_size)
    elsif @direction == 1 # horizontal
      pos_x = @x + ((@width - bar_size) * (@bar_value.to_f / MAX.to_f))
      pos_y = @y 
      over_slider = (m_x > pos_x && m_x < pos_x + bar_size && m_y > pos_y && m_y < pos_y + @height)
    end
    return unless (over_slider || @active)
    @changed = true
    #---------------------------------------------------------
    # changing the current value:
    @active = true
    if @direction == 0 
      @bar_value = MAX * ((m_y - @y - off_set).to_f / (@height - bar_size).to_f).to_f
    else
      @bar_value = MAX * ((m_x - @x - off_set).to_f / (@width - bar_size).to_f).to_f
    end
    @bar_value = MAX if @bar_value > MAX
    @bar_value = 0 if  @bar_value < 0
    #print("working thus far. (#{@bar_value})\n")
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw screen related imagery to the Gosu Window.
  #---------------------------------------------------------------------------------------------------------
  def draw
    super
    #---------------------------------------------------------
    # draw back of bar
    case @style
    when 1 # thin
      if @direction == 0 # vertical
        $program.draw_rect(@x + @width / 4, @y, @width / 2, @height, @color, @z)
      else               # horizontal
        $program.draw_rect(@x, @y + @height / 4, @width, @height / 2, @color, @z)
      end
    else # defualt is full rect drawn.
      $program.draw_rect(@x, @y, @width, @height, @color, @z)
    end
    #---------------------------------------------------------
    # draw slider object
    if @direction == 0 
      y = @y + ((@height - bar_size) * (@bar_value.to_f / MAX.to_f))
      $program.draw_rect(@x, y, @width, bar_size, @hcolor, @z + 1)
   else
      x = @x + ((@width - bar_size) * (@bar_value.to_f / MAX.to_f))
      $program.draw_rect(x, @y, bar_size, @height, @hcolor, @z + 1)
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called when the parent class is destroyed.
  #---------------------------------------------------------------------------------------------------------
  def destroy
    
  end
end


#===============================================================================================================================
# This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either Version 3 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free 
# Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#===============================================================================================================================
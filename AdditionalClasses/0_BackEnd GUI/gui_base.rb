#===========================================================================================================
# !!!   GUI_Base.rb |  Parent class for most of the program display interfaces.
#-----------------------------------------------------------------------------------------------------------
#  The basis for all window objects in game.
#-----------------------------------------------------------------------------------------------------------
# Version 0.5
# Date: 2/20/19
#===========================================================================================================
class GUI_Base
  #--------------------------------------------------------------------------
  attr_accessor :x, :y, :z, :width, :height, :visible, :active, :angle, :zorder, :mode, :color
  #---------------------------------------------------------------------------------------------------------
  #D: Create klass object. Available instance options are:
  #D: ( :x, :y, :z, :width, :height, :visible, :active, :angle, :zorder, :mode, :color )
  #---------------------------------------------------------------------------------------------------------
  def initialize(options = {})
    @wait_time = 20
    #--------------------------------------
    self.color  =  options[:color]  || Gosu::Color::WHITE.dup
    self.alpha  =  options[:alpha]  || 255
    self.mode   =  options[:mode]   || :default
    @x =  options[:x]     || $program.width/2  #DV Screen X position of the window.
    @y =  options[:y]     || 100              #DV Screen Y position of the window.
    @z = options[:zorder] || 100              #DV Z draw order of the window in Gosu::Window
    @visible = true  #DV Draw or hide the display of the window.
    @active  = true  #DV Prevent any input updates of the window.
    @width   = 0     #DV Width value of the window.
    @height  = 0     #DV Height value of the window.
    #--------------------------------------
    @string_img   = nil #DV Image table that represent the text characters used for string_image display.
    @image_string = {}  #DV List of all the strings to be draw using the @string_image
    @spritedata   = {}  #DV Used for mouse sprite items in window.
    @mouse_index  = nil #DV Current item under the mouse if applicable.
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Add a new intractable mouse item into the window class. 
  #---------------------------------------------------------------------------------------------------------
  def new_mouseitem(label = "", object)
    @spritedata = {} if @spritedata.nil?
    sprite = @spritedata[label]
    return true unless sprite.nil?
    @spritedata[label] = object
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw a progress bar for display, maybe health or load percentage?
  #D: { :x, :y, :z, :width, :height, :is_hor, :color_fill, :color_back, :min, :max }
  #---------------------------------------------------------------------------------------------------------
  def guidraw_progress_bar(options = {})
    # grab settings
    x = options[:x] || 0
    y = options[:y] || 0
    z = options[:z] || 100
    min = options[:min] || 0
    max = options[:max] || 1
    width  = options[:width]  || 100
    height = options[:height] || 100
    is_hor = options[:is_hor].nil? ? true : options[:is_hor]
    color_fill = options[:fill]    || 0xFF_00ff00
    color_back = options[:bgcolor] || 0xFF_ffffff
    # build the bar display
    x += 2; y += 2 # bit of a boarder acound the fill
    width -= 4; height -= 4
    $program.draw_rect(x, y, width, height, color_back, z)
    # draw the fill ammount
    per = (min.to_f / max.to_f)
    per = 1.0 if per > 1.0 # 100%
    if is_hor
      $program.draw_rect(x, y, width * per, height, color_fill, z + 1)
    else # vertical bar
      value = height * per
      $program.draw_rect(x, y + height - value, width, value, color_fill, z + 1)
    end
    
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Get objects alpha-value (internally stored in @color.alpha)
  #---------------------------------------------------------------------------------------------------------
  def alpha
    return @color.alpha
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Set objects alpha-value (internally stored in @color.alpha)
  #D: If out of range, set to closest working value. this makes fading simpler.
  #---------------------------------------------------------------------------------------------------------
  def alpha=(value)
    value = 0   if value < 0
    value = 255 if value > 255
    @color.alpha = value
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Sets angle, normalize it to between 0..360
  #---------------------------------------------------------------------------------------------------------
  def angle=(value)
    if value < 0
      value = 360+value
    elsif value > 360
      value = value-360
    end
    @angle = value
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Disable automatic calling of draw and draw_trait each game loop
  #---------------------------------------------------------------------------------------------------------
  def hide!
    @visible = false
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Enable automatic calling of draw and draw_trait each game loop
  #---------------------------------------------------------------------------------------------------------
  def show!
    @visible = true
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Returns true if visible (not hidden)
  #---------------------------------------------------------------------------------------------------------
  def visible?
    return @visible == true
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Remove all string image data.
  #---------------------------------------------------------------------------------------------------------
  def clear_all
    @string_img = nil
    self.clear_string_images
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Returns a boolean value if the window is active.
  #---------------------------------------------------------------------------------------------------------
  def active?
    #return true
    return (@active && self.visible?)
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Update input loop for GUI functions. 
  #---------------------------------------------------------------------------------------------------------
  def update
    if $program.nil? # exiting the game?
      self.destroy
      return
    end
    return unless self.active?
    update_mouse_items
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw pixels onto the screen, called per graphic frame update. 
  #---------------------------------------------------------------------------------------------------------
  def draw
    return unless self.visible?
    draw_mouse_items
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Rounds an Float value to a number of decimal places and converts it to a string for display.
  #---------------------------------------------------------------------------------------------------------
  def decimal_text(value, to_decimal = 2) # number of zeros places to keep after the decimal
    return sprintf("%.#{to_decimal}f", value.round(to_decimal))
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw if any intractable mouse items to game screen.
  #---------------------------------------------------------------------------------------------------------
  def draw_mouse_items
    return if @spritedata.nil?
    @spritedata.each_value{|sprite| sprite.draw unless sprite.nil?}
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Call updates to all intractable mouse items.
  #---------------------------------------------------------------------------------------------------------
  def update_mouse_items
    return if @spritedata.nil?
    self.mouse_operation
    @spritedata.each_value{|sprite| sprite.update unless sprite.nil?}
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Remove a mouse item from life itself only using its label.
  #---------------------------------------------------------------------------------------------------------
  def remove_mouseitem(label = "")
    return if @spritedata[label].nil?
    @spritedata[label].dispose
    @spritedata[label].opacity = 0
    @spritedata.delete(label)
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Move a mouse item to a new screen location.
  #---------------------------------------------------------------------------------------------------------
  def move_mouseitem(label = "", x = 0, y = 0)
    sprite = @spritedata[label]
    return false if sprite.nil?
    sprite.x = x
    sprite.y = y
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Grab the sprite item that matches the label provided.
  #---------------------------------------------------------------------------------------------------------
  def get_mouseitem(label = "")
    return @spritedata[label]
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Clean up GC data on window disposal for things like state class changes. 
  #---------------------------------------------------------------------------------------------------------
  def destroy_gui
    unless @spritedata.nil?
      @spritedata.each_value do |sprite| 
        unless sprite.nil?
          sprite.destroy
        end
      end
    end
    @spritedata = nil
  end
  #---------------------------------------------------------------------------------------------------------
  #D:  Update current object under mouse if any and flag itself.
  #---------------------------------------------------------------------------------------------------------
  def mouse_operation
    px, py = $program.mouse_x - 3, $program.mouse_y - 3
    return if px.nil? || py.nil? || [px, py] == @olds
    @olds = [px, py] 
    return if @spritedata.nil?
    @mouse_index = nil
    @spritedata.each do |label, sprite|
      next if sprite.nil?
      if sprite.mouse_hover?(px, py)
        @mouse_index = label
      end
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Check to make sure the mouse is over the displayed window.
  #---------------------------------------------------------------------------------------------------------
  def mouse_in_window?
    px, py = $program.mouse_x - 3, $program.mouse_y - 3
    return (px > @x && px < @x + @width && py > @y && py < @y + @height)
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Check if call function of mouse item is successful or not and call it. 
  #---------------------------------------------------------------------------------------------------------
  def call_mouse_action?
    return false unless @active
    return false if @mouse_index.nil?
    return if @spritedata == {}
    unless @spritedata[@mouse_index].action # call action associated with sprite index at mouse location
      self.error_catch_print_info
      return false
    end
    return true
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Information about how to debug errors when mouse item calls fail to run. Gives details on how to bypass the running net
  #D: for more information on how to trace the bug back for where it might be located at.
  #---------------------------------------------------------------------------------------------------------
  def error_catch_print_info
    # Here is where you should paste in your call method when advanced debugging.
    # The function 'call_mouse_action?' should be added into the window class
    # that the mouse items reference back into. 
    unless $destroyd_call_lag
      print("------------------------------------------------------------------------\n")
      print("Check to see if your mouse item's call action is returning a value.\n")
      print("Try adding \"return true\" to the call action for the item above ^.\n")
      print("------------------------------------------------------------------------\n")
    end
    $destroyd_call_lag = nil
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
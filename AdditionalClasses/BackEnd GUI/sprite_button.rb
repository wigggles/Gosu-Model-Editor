#===============================================================================================================================
# !!!  Sprite_Button.rb |  A on screen interactive sprite for program Window_Base classes.
#-----------------------------------------------------------------------------------------------------------------------------
# Version 0.5
# Date: 2/20/19
#===============================================================================================================================
# Sprite Button
#===============================================================================================================================
class Sprite_Button
#K----------------------------------------------------------------------------------------------------------------------------------------------------
# An easy way to create mouse interactive sprite item inside of game windows.
#
# A list of avaiable option flags to define the button on creation:
# 
#   options[:adult_class] || nil
#   options[:action]      || nil
#   options[:text]        || ''
#   options[:font_size]   || 24
#   options[:x]           || 0
#   options[:y]           || 0
#   options[:z]           || 10
#   options[:img]         || nil
#   options[:align]       || 0
#   options[:buff]        || 2
#   options[:color]       || [0xff_ff00ff, 0xff_cc00ff]
#   options[:width]       || @text.width
#   options[:height]      || font_size
#   options[:mute]        || false
#
#K-----------------------------------------------------------------------------------------------------------------------------------------------------
  USE_HSOUND = false # play sound or music depending on object highlighted.

  attr_accessor :is_highlighted, :x, :y, :z, :color, :hcolor, :text, :font, :width, :height
  #---------------------------------------------------------------------------------------------------------
  #D: Creates the Kernel Class (klass) instance.
  #---------------------------------------------------------------------------------------------------------
  def initialize(options = {})
    @x = options[:x] || 0
    @y = options[:y] || 0
    @z = options[:z] || 10
    @align = options[:align]  || 0 #DV Alignment to draw the button at. (0: left, 1: center, 2: right)
    @mute  = options[:mute]   || false
    action = options[:action] || nil
    set_action(action)
    @text = options[:text] || ''
    @image = options[:img] || nil
    unless @image.nil?
      if @image.is_a?(Array)
        unless @image[0].is_a?(Gosu::Image)
          puts "Sprite button was given an object as an image that was not a Gosu::Image"
          return nil
        end
      else
        puts "Sprite button needs to be an array of normal and depressed button view."
        return nil
      end
    end
    puts "Button #{@text} was made. #{@x}, #{@y}"
    @adult_pointer = options[:adult_class] || nil
    if @adult_pointer.nil? # check if call method fro action is properly set up.
      print("Error with sprite button (#{@text}), skipping\n")
      return nil
    end
    @played_se = false
    @is_highlighted = false
    @is_depresed = false
    font_size = options[:font_size] || 24
    @font = $program.font(nil, font_size)
    text_width = @text.length * font_size #@font.text_width(@text, 1.0)
    @width  = options[:width]  || text_width
    @height = options[:height] || font_size
    @box_edge_buf = options[:buff] || 2 #DV Add a little to the box so not touching text on edges.
    color = options[:color] || [0xff_ff00ff, 0xff_cc00ff]
    @font_color = [0xff_ffffff, 0xff_000000]
    @color  = color[0] #DV Red, Green, Blue, Alpha (00, 00, 00, 00) (ff, ff, ff, ff)
    @hcolor = color[1] #DV Mouse over box hover color
    case @align
    when 0
      # do nothing, defaults to left.
    when 1
      # center
      @x -= @width / 2
    when 2
      # in order align every button right, the longest length needs to be passed along.
    end
    @destroyed = false #DV Value will be set true if the animation is in the process of being destroyed.
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Return the defined action call for this button used on its owner class the object is contianed in.
  #---------------------------------------------------------------------------------------------------------
  def what_action_is
    return @action
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw a box on screen using colors.
  #---------------------------------------------------------------------------------------------------------
  def draw_image_backer
    if @is_highlighted
      @image[1].draw(tx, ty, @z)
    else
      @image[0].draw(tx, ty, @z)
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Uses Gosu hex colors, sets the variables that draw with them.
  #--------------------------------------------------------------------------------------------------------
  def set_colors(colors = [])
    @color  = color[0]
    @hcolor = color[1] 
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Plays a sound effect if desired when the button is hovered over.
  #--------------------------------------------------------------------------------------------------------
  def play_hover_se
    return if @mute
    return unless USE_HSOUND
    if @played_se == false
      #AudioManager.play_sound(SB::CURSOR_1)
      @played_se = true
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Sound effect is played when the button is acted upon.
  #--------------------------------------------------------------------------------------------------------
  def play_action_se
    return if @mute
    #print("playing sound effect. \n")
    #AudioManager.play_sound(SB::SELECT_0)
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Update loop for button behaviors.
  #--------------------------------------------------------------------------------------------------------
  def update
    return nil
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called when the button is disposed and/or when the parent class is destroyed.
  #---------------------------------------------------------------------------------------------------------
  def finalize
    @finalized = true
    @action = nil
    @adult_pointer = nil
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Check to see if the mouse is on-top of the button, then if it is, update sprite actions.
  #---------------------------------------------------------------------------------------------------------
  def mouse_hover?(mouse_x, mouse_y)
    return if @box_edge_buf.nil?
    mouse_x.to_i
    mouse_y.to_i
    #width = @width #+ (@box_edge_buf * 2)
    #x = @x #+ @box_edge_buf
    over_self = (mouse_x > tx && mouse_x < tx + lx && mouse_y > ty && mouse_y < ty + ly)
    @is_highlighted = over_self
    if @is_highlighted
      play_hover_se
    else
      @played_se = false
      @is_depresed = false
    end
    return @is_highlighted
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw onto the Gosu window any images related to the button.
  #---------------------------------------------------------------------------------------------------------
  def draw
    return if $program.nil?
    return if @box_edge_buf.nil?
    if @image.nil?
      draw_button_backer
    else
      draw_image_backer
    end
    draw_button_text
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw text over top of back of button backer graphic.
  #---------------------------------------------------------------------------------------------------------
  def draw_button_text
    x = @x
    y = @y # @box_edge_buf / 2 + @y
    if @is_highlighted
      @font.draw_text(@text, x, y, @z + 1, 1, 1, @font_color[1])
    else
      @font.draw_text(@text, x, y, @z + 1, 1, 1, @font_color[0])
    end
  end
  #---------------------------------------------------------------------------------------------------------
  def tx
    return @x - @box_edge_buf
  end
  #---------------------------------------------------------------------------------------------------------
  def lx
    return @width + @box_edge_buf
  end
  #---------------------------------------------------------------------------------------------------------
  def ty
    return @y - @box_edge_buf
  end
  #---------------------------------------------------------------------------------------------------------
  def ly
    return @height + @box_edge_buf
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw a box on screen using colors.
  #---------------------------------------------------------------------------------------------------------
  def draw_button_backer
    return if @box_edge_buf.nil?
    color  = @is_highlighted  ? @hcolor : @color
    color2 = !@is_highlighted ? @hcolor : @color
    $program.draw_rect(tx, ty, lx + @box_edge_buf, ly + @box_edge_buf,  color, @z)
    $program.draw_rect(tx, ty, lx + @box_edge_buf, ly + @box_edge_buf, color2, @z)
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Return the full button width including the background.
  #---------------------------------------------------------------------------------------------------------
  def full_width
    return (@width + @box_edge_buf)
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Try first to catch errors, and call function from parent class user.
  #---------------------------------------------------------------------------------------------------------
  def action
    return false unless @is_highlighted
    return true if @is_depresed
    @is_depresed = true
    play_action_se
    #print("click action!\n")
    if @action.nil?
      print("There is an error with button\n #{text}\n In: #{@adult_pointer}")
      return false
    end
    # use owner class for method call
    test = @adult_pointer.send(@action) || nil
    if test.nil?
      if @finalized
        return false 
      end
      error_msg = "ERROR WITH: #{@text} | '#{@action}' not found in #{@adult_pointer}\n"
      print(error_msg)
      puts("\nMake sure to return sprite button callback as vlaue 'true' to avoid this notification.")
      return false
    end
    return true
  end
  #--------------------------------------------------------------------------------------------------------
  #D: Calls a method from parent class where the Sprite_Button is located.
  #--------------------------------------------------------------------------------------------------------
  def set_action(class_method = :show_error)
    @action = class_method
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called when the container table or stage has been released to GC.
  #---------------------------------------------------------------------------------------------------------
  def destroy
    @destroyed = true
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Return boolean weather or not the object was destroyed and is waiting for GC clean up.
  #---------------------------------------------------------------------------------------------------------
  def destroyed?
    return @destroyed
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Error catching and processing for the button is done here.
  #--------------------------------------------------------------------------------------------------------
  def show_error
    print("Error showing method during call back.\n")
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
#===============================================================================================================================
# !!!  Sprite_TextField.rb |  A on screen interactive sprite for Window_Base classes that accepts key input.
#-----------------------------------------------------------------------------------------------------------------------------
# Version 0.5
# Date: 2/20/19
#===============================================================================================================================
# Sprite Button
#===============================================================================================================================
class Sprite_TextField < BareObject
#K------------------------------------------------------------------------------------------------------------------------------
# An easy way to create mouse interactive sprite item inside of game windows.
#K------------------------------------------------------------------------------------------------------------------------------
  BLINK_SPEED = 20
  REPEAT_CHARACTER = 10
  
  attr_accessor :is_active, :x, :y, :z, :color, :text, :font
  #---------------------------------------------------------------------------------------------------------
  #D: Creates the Kernel Class (klass) instance.
  #---------------------------------------------------------------------------------------------------------
  def initialize(options = {})
    @x = options[:x] || 0
    @y = options[:y] || 0
    @z = options[:z] || 10
    @text = options[:text] || ''
    font_size = options[:font_size] || 24
    @font  = Gosu::Font.new($program, "verdana", font_size)
    @width  = options[:width]  || 100
    @height = options[:height] || font_size * 1.5
    @box_edge_buf = font_size / 3 #DV Add a little to the box so not touching text on edges.
    @x += @box_edge_buf
    @color  = options[:color] || 0xff_353535  #DV Red, Green, Blue, Alpha (00, 00, 00, 00) (ff, ff, ff, ff)
    @is_active = true #DV Allow the text field to be changed?
    @pulse = [0, true] #DV Used to blink the text position.
    @backspace_repeat = [0, 0]
    options = {:color => 0xff_ffffff, :x => @x, :y => @y, :z => @z + 10, :font => "NoticiaText.ttf", :size => font_size}
    @carret = Text_Box.new("|", options)
    super()
    #print("new_textfield \n#{options[:x]},  #{options[:y]}, #{options[:z]}\n\n")
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Uses Gosu hex colors, sets the variables that draw with them.
  #--------------------------------------------------------------------------------------------------------
  def set_bg_color(colors = 0xFF_000000) # black
    @color  = color
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
    super
    return unless @is_active
    @backspace_repeat[0] -= 1 if @backspace_repeat[0] > 0
    edditing_text
    @carret.update
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called when the button is disposed and/or when the parent class is destroyed.
  #---------------------------------------------------------------------------------------------------------
  def destroy
    @carret.destroy
    super
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Check to see if the mouse is on-top of the field.
  #---------------------------------------------------------------------------------------------------------
  def mouse_hover?(mouse_x, mouse_y)
    return if @box_edge_buf.nil?
    mouse_x.to_i
    mouse_y.to_i
    width = @width + (@box_edge_buf * 2)
    x = @x + @box_edge_buf
    return (mouse_x > x && mouse_x < x + width && mouse_y > @y && mouse_y < @y + @height)
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw onto the Gosu window any images related to the button.
  #---------------------------------------------------------------------------------------------------------
  def draw
    return if $program.nil?
    draw_backer
    draw_text
    @carret.draw
    super
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called when the box is active, allows the text to be edited.
  #---------------------------------------------------------------------------------------------------------
  def edditing_text
    #--------------------------------------
    # when accepting key inputs
    if $program.grab_characters == 'backspace'
      if @backspace_repeat[0] <= 0
        @text.chop! # remove last character
        if @backspace_repeat[1] > 6
          @backspace_repeat[0] = REPEAT_CHARACTER / 4
        else
          @backspace_repeat[0] = REPEAT_CHARACTER
        end
        @backspace_repeat[1] += 1
        @pulse[0] = 0
      end
    else
      @backspace_repeat = [0, 0]
    end
    if $program.grab_characters != @old_key_press
      @old_key_press = $program.grab_characters
      if @pulse[1]
        @pulse = [BLINK_SPEED, false] # reset pulse active bar
      end
      # update text field
      case @old_key_press
      when 'backspace'
        
      when 'space' then add_text(' ')
      when 'tab' then add_text('    ')
      when 'del' then @text = '' # clear all text
      when 'return'
        #play_action_se
      else # add key string to text value
        add_text(@old_key_press.to_s)
      end
    end
    #--------------------------------------
    # blink carret
    if @pulse[0] > 0 
      @pulse[0] -= 1
    else
      @pulse[0] = BLINK_SPEED
      if @pulse[1]
        @carret.text = ""
      else
        @carret.text = "|"
      end
      @pulse[1] = !@pulse[1]
    end
    text_width = @text.length * @font.height #@font.text_width(@text)
    @carret.x = @box_edge_buf / 2 + @x + 
    @carret.y = @box_edge_buf / 2 + @y
  end
  #---------------------------------------------------------------------------------------------------------
  #D:
  #---------------------------------------------------------------------------------------------------------
  def add_text(string)
    text_width =  (@text.length + string) * @font.height # @font.text_width(@text + string)
    if text_width < @width - @box_edge_buf
      @text += string
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw text over top of back of button backer graphic.
  #---------------------------------------------------------------------------------------------------------
  def draw_text
    return if @box_edge_buf.nil?
    x = @box_edge_buf / 2 + @x
    y = @box_edge_buf * 0.8 + @y
    @font.draw_text(@text, x, y, @z + 1)
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw a box on screen using colors.
  #---------------------------------------------------------------------------------------------------------
  def draw_backer
    return if @box_edge_buf.nil?
    width = @width + (@box_edge_buf * 2)
    x = @x - @box_edge_buf
    $program.draw_rect(x, @y, width, @height, @color, @z)
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
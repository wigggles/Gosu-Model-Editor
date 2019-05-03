#===============================================================================================================================
# !!!  Sprite_Menu.rb |  An on screen interactive sprite for program Window_Base classes.
#-----------------------------------------------------------------------------------------------------------------------------
# Version 0.5
# Date: 2/20/19
#===============================================================================================================================
class Sprite_Menu
#K------------------------------------------------------------------------------------------------------------------------------
# Creates an interactive sprite menu using 'Sprite_Button' inside game windows.
#K------------------------------------------------------------------------------------------------------------------------------
  attr_accessor :x, :y, :z
  #---------------------------------------------------------------------------------------------------------
  #D: Creates the Kernel Class (klass) instance.
  #---------------------------------------------------------------------------------------------------------
  def initialize(options = {})
    @x = options[:x] || 0   #DV Screen X position.
    @y = options[:y] || 0 #DV Screen Y position.
    @z = options[:z] || 0   #DV $program.draw 'zorder' (which sprite gets drawn over others?)
    @width   = options[:width]   || 200
    @height  = options[:height]  || 48
    @actions = options[:actions] || {}  #DV Actions for each of the menu items.
    @buttonBoarder = options[:butt_boarder] || 10
    @spacing = 24 # font size generally
    @padding = 16
    @olds = [0, 0] #DV Previous mouse screen location.
    @adult_pointer = options[:adult_class] || nil #DV Class that receives button action calls. 
    @played_se = nil #DV Prevents sound effect looping while changing indexes.
    if @adult_pointer.nil? # check parent before action is set up.
      print("Error with Sprite_Menu in (#{$program.current_stage}). It has no parent class, skipping\n")
      return nil
    end
    @width  = 200
    @height = @actions.length * 48
    @bg_color = 0xff123854
    create_buttons
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Follows active index button action threw during action key trigger.
  #---------------------------------------------------------------------------------------------------------
  def look_for_input_key
    return if $program.nil?
    #--------------------------------------
    if $program.trigger?(:menu_up) # scroll index up
      @buttons[@index].is_highlighted = false rescue nil
      @index -= 1
      if @index < 0 # roll index over if it reached the beginning
        @index = @buttons.length - 1
      end
    #--------------------------------------
    elsif $program.trigger?(:menu_down) # scroll index down
      @buttons[@index].is_highlighted = false rescue nil
      @index += 1
      if @index > @buttons.length - 1 # roll index over if it reached the end
        @index = 0
      end
    #--------------------------------------
    elsif $program.trigger?(:menu_left)
      
    elsif $program.trigger?(:menu_right)
      
    elsif $program.trigger?(:cancel_action)
      
    elsif $program.trigger?(:menu_action)
      call_button? # check for and run any button action currently under the mouse location
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Check for and call action if there is a button currently selected.
  #---------------------------------------------------------------------------------------------------------
  def call_button?
    to_call = @buttons[@index]
    unless to_call.nil?
      #puts "Called sprite button action for menu item (#{to_call.text})"
      to_call.action
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Create the menu list in button form.
  #---------------------------------------------------------------------------------------------------------
  def create_buttons
    @buttons = [] #DV Container for the 'Sprite_Button' array for menu items.
    @index   = -1  #DV Current selected index in the @buttons array.
    colors   = [0xff_0000ff, 0xff_cccccc] # Colors used when drawing the menu [Base, Active]
    options  = {:x => @x + @padding, :y => @padding + @y, :z => @z + 1, :color => colors, :align => 1, :buff => @buttonBoarder}
    options[:adult_class] = @adult_pointer
    @widest_butt = 0
    # build menu array
    @actions.each do |lable, action|
      options[:text]   = lable
      options[:action] = action
      button = Sprite_Button.new(options)
      options[:y] += button.height + @spacing # advance draw index
      @buttons << button
      @widest_butt = button.full_width if @widest_butt < button.full_width
    end
    @buttons.each do |butt| # if align 1
      butt.x += @widest_butt / 2
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Update loop for button behaviors.
  #--------------------------------------------------------------------------------------------------------
  def update
    return if $program.nil?
    index_operation
    look_for_input_key
    return if @destroyd
    return if @buttons.nil?
    @buttons.each do |button| # update each sprite button in the menu
      button.update
      if @index == @buttons.index(button)
        button.is_highlighted = true
      end
      if button.is_highlighted
        if @played_se.nil?
          @played_se = button.text
          #AudioManager.play_sound(SB::CURSOR_1) # play sound effect on index change
        elsif @played_se != button.text
          @played_se = nil
        end
        return
      end
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Update current object under mouse, if any, and make it flag itself.
  #---------------------------------------------------------------------------------------------------------
  def index_operation
    px, py = $program.mouse_x - 3, $program.mouse_y - 3
    return if px.nil? || py.nil? || [px, py] == @olds
    @olds = [px, py] 
    return if @buttons.nil?
    @buttons.each do |sprite|
      next if sprite.nil?
      if sprite.mouse_hover?(px, py)
        @index = @buttons.index(sprite)
        return
      end
    end
    @index = -1
    @played_se = nil
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called when the button is disposed and/or when the parent class is destroyed.
  #---------------------------------------------------------------------------------------------------------
  def destroy
    return if @destroyd
    @destroyd = true
    @buttons.each do |button|
      button.destroy
    end
    @buttons = nil
    @adult_pointer = nil
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw onto the Gosu window any images related to the button.
  #---------------------------------------------------------------------------------------------------------
  def draw
    return if $program.nil?
    return if @destroyd
    $program.draw_rect(@x, @y, width, height, @bg_color, @z)
    for button in @buttons
      button.draw
    end
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Return the width of the menu background based on the widest button generated by provided display text.
  #---------------------------------------------------------------------------------------------------------
  def width
    return @padding * 2 + @widest_butt
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Return the height of the menu background built by the number of buttons * their size.
  #---------------------------------------------------------------------------------------------------------
  def height
    return @padding + ((@spacing + @buttons.last.height) * @buttons.size)
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
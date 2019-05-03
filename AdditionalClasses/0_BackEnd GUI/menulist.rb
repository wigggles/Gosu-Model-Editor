#===========================================================================================================
# !!!  MenuList.rb  |  Used for quick menu creation.
#-----------------------------------------------------------------------------------------------------------
# Version 0.5
# Date: 2/20/19
#===========================================================================================================
class MenuList < BareObject
#K----------------------------------------------------------------------------------------------------------
# The layout and functionality of menu lists based objects used in game.
#K----------------------------------------------------------------------------------------------------------
  attr_accessor :menu_items, :visible
  #---------------------------------------------------------------------------------------------------------
  #D: Create Kernel Class (klass) object.
  #---------------------------------------------------------------------------------------------------------
  def initialize(options = {})
    super
    #--------------------------------------
    @menu_items = options.delete(:menu_items)     # || {"Exit" => :exit}
    @x = options.delete(:x) || $program.width / 2
    @y = options.delete(:y) || 100
    @spacing = options.delete(:spacing) || 100
    @items = []
    @visible = true
    #--------------------------------------
    y = @spacing
    menu_items.each do |key, value|
      item = if key.is_a?(String)
        Text_Box.new(key, options.dup)
      elsif key.is_a?(Image)
        GameObject.new(options.merge!(:image => key))
      elsif key.is_a?(GameObject)
        menu_item.options.merge!(options.dup)
        menu_item
      end
      #--------------------------------------
      item.options[:on_select] = method(:on_select)
      item.options[:on_deselect] = method(:on_deselect)
      item.options[:action] = value
      #--------------------------------------
      item.x = @x
      item.y = @y + y
      y += item.height + @spacing
      @items << item
    end
    @selected = options[:selected] || 0
    step(0, true)
    #--------------------------------------
    self.input = {
      [:up, :gp_up, :wheel_up]       => lambda{step(-1)},
      [:down, :gp_down, :wheel_down] => lambda{step(1)}, 
      [:return, :space, :gp_0]       => :select
    }
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Advance the selection index in the list by (value) amount. 
  #---------------------------------------------------------------------------------------------------------
  def step(value, mute = false)
    AudioManager.play_sound(SB::CURSOR_1) unless mute
    selected.options[:on_deselect].call(selected)
    @selected += value
    @selected = @items.count-1  if @selected < 0
    @selected = 0               if @selected == @items.count
    selected.options[:on_select].call(selected)
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Action that the object selected in the list does when input action is called upon it.
  #---------------------------------------------------------------------------------------------------------
  def select
    AudioManager.play_sound(SB::SELECT_1)
    dispatch_action(selected.options[:action], self.parent)
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Return the object currently at the selection index value in the list.
  #---------------------------------------------------------------------------------------------------------
  def selected
    return(@items[@selected])
  end
  #---------------------------------------------------------------------------------------------------------
  #D: What the object tin the list does when the selection index does not match its index location.
  #---------------------------------------------------------------------------------------------------------
  def on_deselect(object)
    object.color = Gosu::Color::WHITE
  end
  #---------------------------------------------------------------------------------------------------------
  #D: What the object in the list does when the selection index matches its index location.
  #---------------------------------------------------------------------------------------------------------
  def on_select(object)
    object.color = Gosu::Color::RED
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Draw image related items to the Gosu::Window ($program) class.
  #---------------------------------------------------------------------------------------------------------
  def draw
    @items.each { |item| item.draw }
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Calls the specified action (function) in the current GameState class on top of the $program.state_manager
  #---------------------------------------------------------------------------------------------------------
  # DRY this up with input dispatcher somehow 
  def dispatch_action(action, object)
    case action
    when Symbol, String
      object.send(action)
    else
      # possibly raise an error? This ought to be handled when the input is specified in the first place.
    end
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
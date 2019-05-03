#===============================================================================================================================
# !!!   Bare_Object.rb  |  A bare class that is the skeleton for any interactive program object.
#-----------------------------------------------------------------------------------------------------------------------------
# Version 0.5
# Date: 2/20/19
#===============================================================================================================================
class BareObject
  attr_reader :id, :type, :destroyed
  attr_accessor :z
  #---------------------------------------------------------------------------------------------------------
  #D: Create Klass object in GC.
  #---------------------------------------------------------------------------------------------------------
  def initialize(options = {})
    @id    = options[:id]   || 0
    @type  = options[:type] || :nil
    @x     = options[:x]    || 0      #DV Screen location X. Float
    @y     = options[:y]    || 0      #DV Screen location Y. Float
    @z     = options[:z]    || 25     #DV Z order to draw animation to monitor screen.
    @image = nil
    @destroyed = false #DV Value will be set true if the animation is in the process of being destroyed.
  end
  #---------------------------------------------------------------------------------------------------------
  # Set or change of the X reference value.
  #---------------------------------------------------------------------------------------------------------
  def x=(value)
    @x = value
  end
  #---------------------------------------------------------------------------------------------------------
  # Get the X reference value, is a float value.
  #---------------------------------------------------------------------------------------------------------
  def x
    return @x
  end
  #---------------------------------------------------------------------------------------------------------
  # Set or change of the Y reference value.
  #---------------------------------------------------------------------------------------------------------
  def y=(value)
    @y = value
  end
  #---------------------------------------------------------------------------------------------------------
  # Get the Y reference value, is a float value.
  #---------------------------------------------------------------------------------------------------------
  def y
    return @y
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called after stage $program swap in some cases.
  #---------------------------------------------------------------------------------------------------------
  def setup(*args)
    
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called on a ms clock threw Gosu.tick function call back in the Program class then pushed down stream.
  #---------------------------------------------------------------------------------------------------------
  def update(*args)
    
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called on FPS draw in Program Gosu.draw function.
  #---------------------------------------------------------------------------------------------------------
  def draw(*args)
    
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Called when the container table or stage has been released to GC.
  #---------------------------------------------------------------------------------------------------------
  def destroy(*args)
    @destroyed = true
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Return boolean weather or not the object was destroyed and is waiting for GC clean up.
  #---------------------------------------------------------------------------------------------------------
  def destroyed?
    return @destroyed
  end
  #---------------------------------------------------------------------------------------------------------
  #D: Unified load in center image on object map location. Call super when creating animations for objects.
  #---------------------------------------------------------------------------------------------------------
  def build_animations
    unless @image.nil?
      @width  = @image.width
      @height = @image.height
      # center location based on graphic size
      @x += (@width / 2)
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
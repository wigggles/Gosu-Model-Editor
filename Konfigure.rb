#=====================================================================================================================================================
# Global configuration settings.
#=====================================================================================================================================================
module Konfigure
  #---------------------------------------------------------------------------------------------------------
  RESOLUTION     = [800, 600] # Display Gosu::Window size.
  ISFULLSCREEN   = false      # Draw in full screen mode?
  NUMBEROF_BOXES = 4          # work windows that divide the Gosu::Window
  #---------------------------------------------------------------------------------------------------------
  UP_MS_DRAW     = 15 # 60 FPS = 16.6666 : 50 FPS = 20.0 : 40 FPS = 25.222
  DEFAULT_FONT   = 'NoticiaText.ttf'
  #---------------------------------------------------------------------------------------------------------
  # Defualt control scheme settings. lots of buttons to potentionally map to things.
  DEFAULT_CONTROLS = { 
    #--------------------------------------
    # In game menu navigation
    :menu_up          => [:up   , :gp_up],
    :menu_down        => [:down , :gp_down],
    :menu_left        => [:left , :gp_left],
    :menu_right       => [:right, :gp_right],
    :menu_scroll_up   => [:gp_rbump, :mouse_wu],
    :menu_scroll_down => [:gp_lbump, :mouse_wd],
    :menu_action      => [:l_clk, :gp_0, :space, :return],
    #--------------------------------------
    # 3D controls
    :move_up        => [:up  , :let_w, :gp_up],
    :move_down      => [:down, :let_s, :gp_down],
    :turn_left      => [:let_a, :left],
    :turn_right     => [:let_d, :right],
    :move_forword   => [:let_w, :up],
    :move_backwards => [:let_s, :down],
    # common controls
    :move_left    => [:left , :let_a, :gp_left],
    :move_right   => [:right, :let_d, :gp_right],
    :move_crouch  => [:lctrl],
    :move_jump    => [:space],
  
    :mouse_lclick  => [:l_clk],
    :mouse_rclick  => [:r_clk],
    :cancel_action => [:esc, :gp_cl],
    #--------------------------------------
    # can not be used in above mapping, use both shifts individually.
    :shift => [:lshift, :rshift], # this is for keyboard character input modes only.
    :ctrl  => [:lctrl, :rctrl],
    :alt   => [:lalt, :ralt]
   }
  #---------------------------------------------------------------------------------------------------------
end
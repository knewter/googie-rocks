require 'ruby-debug'
require 'gosu'
require 'texplay'
require 'chipmunk'
require './extensions'
require './player'

class GameWindow < Gosu::Window
  WIDTH = 960
  HEIGHT = 662
  # The number of steps to process every Gosu update
  SUBSTEPS = 6
  INFINITY = 1.0/0

  def initialize
    super WIDTH, HEIGHT, false
    self.caption = "Googie Look Under Rocks"

    # Time increment over which to apply a physics "step" ("delta t")
    @dt = (1.0/60.0)

    # Create our Space and set its damping
    # A damping of 0.5 causes the player to slow down rather quickly
    @space = CP::Space.new
    @space.damping = 0.5
    @space.gravity = CP::Vec2.new(0.0, 40.0)

    ### Handle platform physics
    @platform_body = CP::Body.new_static
    @platform_shape = CP::Shape::Segment.new(@platform_body, CP::Vec2.new(0.0, 0.0), CP::Vec2.new(WIDTH, 0.0), 2)
    @platform_shape.body.p = CP::Vec2.new(0.0, 550.0)
    @platform_shape.collision_type = :platform
    #@space.add_body(@platform_body)
    @space.add_static_shape(@platform_shape)
    ### End Handle platform physics

    ### Handle player physics
    # Create the Body for the Player
    @player_body = CP::Body.new(10.0, 150.0)
    # Create the shape for the player, circle for now
    @player_shape = CP::Shape::Circle.new(@player_body, 100, CP::Vec2.new(0.0, 0.0))
    # The collision_type of a shape allows us to set up special collision behavior
    # based on these types.  The actual value for the collision_type is arbitrary
    # and, as long as it is consistent, will work for us; of course, it helps to have it make sense
    @player_shape.collision_type = :player
    @space.add_body(@player_body)
    @space.add_shape(@player_shape)
    ### End handle player physics
    
    @background_image = Gosu::Image.new(self, "gfx/test-background.jpg", true)
    @player = Player.new(self, @player_shape)
    @player_shape.object = @player
    @player.warp(CP::Vec2.new(320.0, HEIGHT - @player.height))

    @space.add_collision_func(:player, :platform) do |player, platform|
      player.object.jumping = false
      true
    end
  end
  
  def update
    # Step the physics environment SUBSTEPS times each update
    SUBSTEPS.times do
      # When a force or torque is set on a Body, it is cumulative
      # This means that the force you applied last SUBSTEP will compound with the
      # force applied this SUBSTEP; which is probably not the behavior you want
      # We reset the forces on the Player each SUBSTEP for this reason
      @player.shape.body.reset_forces
      
      # Wrap around the screen to the other side
      @player.validate_position
      
      # Check keyboard
      if button_down? Gosu::Button::KbLeft
        @player.walk_left
      end
      if button_down? Gosu::Button::KbRight
        @player.walk_right
      end
      if button_down? Gosu::Button::KbUp
        @player.jump
      end
      
      # Perform the step over @dt period of time
      # For best performance @dt should remain consistent for the game
      @space.step(@dt)
    end
  end
  
  def draw
    @player.draw
    @background_image.draw(0, 0, 0)

    #draw_debug
  end

  # The goal of this method is to draw the bounding boxes for all of the objects in the space....however, this is no dice currently, so i just iterate over a couple that I know about for now.
  def draw_debug
    #[@player_shape, @platform_shape].each do |shape|
      
    #end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show

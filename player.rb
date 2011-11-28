class Player
  attr_reader :shape
  attr_accessor :jumping

  def initialize(window, shape)
    @image = Gosu::Image.new(window, "gfx/player.png", false)

    @shape = shape
    shape.body.p = CP::Vec2.new(0.0, 0.0) # position
    shape.body.v = CP::Vec2.new(0.0, 0.0) # velocity
    shape.body.a = (3*Math::PI/2.0) # angle in radians; faces towards top of screen

    @direction = :right
    @jumping = false
  end

  def height
    @image.height
  end

  def warp(vect)
    shape.body.p = vect
  end
  
  def walk_left
    @direction = :left
    shape.body.apply_force((CP::Vec2.new(-1.0, 0.0) * (3000.0/GameWindow::SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
  
  def walk_right
    @direction = :right
    shape.body.apply_force((CP::Vec2.new(1.0, 0.0) * (3000.0/GameWindow::SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
  
  def jump
    unless jumping
      shape.body.apply_impulse((CP::Vec2.new(0.0, 1.0) * (-25000.0/GameWindow::SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
      @jumping = true
    end
  end

  def validate_position
    l_position = CP::Vec2.new(shape.body.p.x % GameWindow::WIDTH, shape.body.p.y % GameWindow::HEIGHT)
    shape.body.p = l_position
  end

  def draw
    if @direction == :left
      x_factor = -1
      x_translated = shape.body.p.x + @image.width
    else
      x_factor = 1
      x_translated = shape.body.p.x
    end
    #@image.draw_rot(x_translated, shape.body.p.y, 1, x_factor, shape.body.a.radians_to_gosu)
    @image.draw(x_translated, shape.body.p.y, 2, x_factor)
  end
end

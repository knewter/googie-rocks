class Platform
  attr_accessor :shape
  def initialize(window, shape)
    @image = Gosu::Image.new(window, "gfx/platform.png", false)

    @shape = shape
    shape.body.p = CP::Vec2.new(0.0, 0.0) # position
    shape.body.v = CP::Vec2.new(0.0, 0.0) # velocity
  end

  def warp(vect)
    shape.body.p = vect
  end

  def height
    @image.height
  end

  def width
    @image.width
  end

  def draw
    @image.draw(shape.body.p.x, shape.body.p.y, 1)
  end
end

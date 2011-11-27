class Player
  def initialize(window)
    @image = Gosu::Image.new(window, "gfx/player.png", false)
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @direction = :left
  end

  def height
    @image.height
  end

  def warp(x, y)
    @x, @y = x, y
  end
  
  def walk_left
    @direction = :left
    @vel_x -=1
  end
  
  def walk_right
    @direction = :right
    @vel_x +=1
  end
  
  def jump
    @vel_y -= 1
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= GameWindow::WIDTH
    @y %= GameWindow::HEIGHT
    
    @vel_x *= 0.85
    @vel_y *= 0.85
  end

  def draw
    if @direction == :left
      x_factor = -1
      x_translated = @x + @image.width
    else
      x_factor = 1
      x_translated = @x
    end
    @image.draw(x_translated, @y, 1, x_factor)
  end
end

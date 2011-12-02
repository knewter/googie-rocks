class GameObject
  def log(message)
    STDOUT.puts message
  end

  def collides_left_with?(object)
    return false unless moving_left?
    horizontal_bits = (self.left_edge <= object.right_edge) && (self.last_left_edge > object.right_edge)
    vertical_bits   = (self.bottom_edge != object.top_edge) && (self.top_edge != object.bottom_edge)
    horizontal_bits && vertical_bits
  end

  def collides_right_with?(object)
    return false unless moving_right?
    horizontal_bits = (self.right_edge >= object.left_edge) && (self.last_right_edge < object.left_edge)
    vertical_bits   = (self.bottom_edge != object.top_edge) && (self.top_edge != object.bottom_edge)
    horizontal_bits && vertical_bits
  end

  def collides_up_with?(object)
    vertical_bits   = (self.top_edge <= object.bottom_edge) && (self.last_top_edge > object.bottom_edge)
    horizontal_bits = (self.left_edge != object.right_edge) && (self.right_edge != object.left_edge)
    vertical_bits && horizontal_bits
  end

  def collides_down_with?(object)
    vertical_bits   = (self.bottom_edge >= object.top_edge) && (self.last_bottom_edge < object.top_edge)
    horizontal_bits = (self.left_edge != object.right_edge) && (self.right_edge != object.left_edge)
    vertical_bits && horizontal_bits
  end

  def collides_horizonally_with?(object)
    collides_left_with?(object) || collides_right_with?(object)
  end

  def collides_vertically_with?(object)
    collides_up_with?(object) || collides_down_with?(object)
  end

  def left_edge
    x - self.width/2
  end

  def last_left_edge
    last_x - self.width/2
  end

  def right_edge
    x + self.width/2
  end

  def last_right_edge
    last_x + self.width/2
  end

  def top_edge
    y - self.height/2
  end

  def last_top_edge
    last_y - self.height/2
  end

  def bottom_edge
    y + self.height/2
  end

  def last_bottom_edge
    last_y + self.height/2
  end

  def moving_left?
    @x < @last_x
  end

  def moving_right?
    @x > @last_x
  end
end


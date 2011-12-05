class Player < Chingu::GameObject  
  trait :bounding_box, :debug => false
  traits :timer, :collision_detection, :velocity

  attr_accessor :last_x, :last_y, :direction, :lives, :score
  
  def setup
    self.input = {  [:holding_left, :holding_a] => :move_left, 
                    [:holding_right, :holding_d] => :move_right,
                    [:holding_up, :holding_w, :holding_space] => :jump
                  }

    # Load the full animation from tile-file media/droid.bmp
    @animation = Chingu::Animation.new(:file => "matthew_jumping_animation.png", :width => 190, :height => 210, :delay => 200)
    @animation.frame_names = { :standing => 0..0, :walking => 1..2, :jumping => 3..6 }
    
    # Start out by animation frames (contained by @animation[:jumping])
    @frame_name = :standing
    
    @speed = 3
    @last_x, @last_y = @x, @y
    @lives = 3
    @score = 0
    
    self.acceleration_y = 0.5
    update
  end

  def warp(coords)
    self.x = coords[0]
    self.y = coords[1]
  end

  def move(x,y)
    @last_direction = :right if x > 0
    @last_direction = :left if x < 0
    
    @x += x
    @x = @last_x  if self.parent.viewport.outside_game_area?(self)
    
    @y += y
    #@y = @last_y  if self.parent.viewport.outside_game_area?(self)
  end
    
  def move_left
    @frame_name = :walking
    move(-@speed, 0)
  end

  def move_right
    @frame_name = :walking
    move(@speed, 0)
  end

  def jump
    unless @jumping
      @frame_name = :jumping
      self.velocity_y = -10
      @jumping = true
      Sound["woohoo.wav"].play(0.5)
    end
    #move(0, -@speed*3)
  end

  def die!
    @lives -= 1
  end

  def game_over?
    @lives == 0
  end
  
  # We don't need to call super() in update().
  # By default GameObject#update is empty since it doesn't contain any gamelogic to speak of.
  def update
    # Move the animation forward by fetching the next frame and putting it into @image
    # @image is drawn by default by GameObject#draw
    @image = @animation[@frame_name].next
    
    if @x == @last_x && @y == @last_y
    else
      # Save the direction to use with bullets when firing
      @direction = [@x - @last_x, @y - @last_y]
    end

    begin
      each_collision(Block, GrassBlock) do |player, block|
        if player.collides_horizonally_with?(block) 
          @x = @last_x
        end
        if player.collides_vertically_with?(block)
          @jumping = false
          @y = @last_y
          self.velocity_y = 0
        end
      end

      each_collision(GoldCoin) do |player, coin|
        coin.destroy
        Sound["yesss.wav"].play(0.5)
        player.score += coin.points
      end
    rescue
    end

    # Default to the standing frame
    @frame_name = :standing
    @last_x, @last_y = @x, @y
  end
end


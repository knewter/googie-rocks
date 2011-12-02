class Game < Chingu::Window
  def initialize
    super(800, 600, false)            # leave it blank and it will be 800,600,non fullscreen

    switch_game_state(Googie)
    self.input = { :escape => :exit, :holding_p => :game_over } # exits example on Escape
  end
  
  def update
    super
    self.caption = "FPS: #{self.fps} milliseconds_since_last_tick: #{self.milliseconds_since_last_tick}"
  end

  def game_over
    switch_game_state(GameOver)
  end
end

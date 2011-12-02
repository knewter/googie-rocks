class Game < Chingu::Window
  def initialize
    super(800, 600, true)            # leave it blank and it will be 800,600,non fullscreen

    switch_game_state(Googie.new)
    self.input = { :escape => :exit } # exits example on Escape
  end
  
  def update
    super
    self.caption = "FPS: #{self.fps} milliseconds_since_last_tick: #{self.milliseconds_since_last_tick}"
  end
end

class Googie < GameState
  # This adds accessor 'viewport' to class and overrides draw() to use it.
  trait :viewport

  attr_accessor :spawn_point

  def initialize(options = {})
    super

    @spawn_point = [200, 100]
    
    self.input = { :escape => :exit, :e => :edit }

    self.viewport.lag = 0.8                         # 0 = no lag, 0.99 = a lot of lag.
    self.viewport.game_area = [0, 0, 10000, 1400]   # Viewport restrictions, full "game world/map/area"
    
    @file = File.join(ROOT, "levels", self.filename + ".yml")
    load_game_objects(:file => @file)

    @player = Player.create(:x => @spawn_point[0], :y => @spawn_point[1], :image => Image["gfx/player.png"])

    @lives_text = Text.create("Lives:", :x => viewport.x, :y => viewport.y, :color => Gosu::Color::WHITE)
  end

  def edit
    push_game_state GameStates::Edit.new(:file => @file, :grid => [32,32], :except => [Player], :debug => false)
  end

  def update
    off = 200
    self.viewport.x_target = @player.x - $window.width/2 + off
    self.viewport.y_target = @player.y - $window.height/2 - 100
    @lives_text.x = viewport.x
    @lives_text.y = viewport.y
    @lives_text.text = "Lives: #{@player.lives}"

    # Die if you fall below the game area
    if @player.y >= viewport.game_area.height
      @player.die!
      @player.warp(spawn_point)
    end

    super
  end
end

class Googie < GameState
  # This adds accessor 'viewport' to class and overrides draw() to use it.
  trait :viewport

  attr_accessor :spawn_point

  def initialize(options = {})
    super

    @game_area   = [10000, 1400]
    @spawn_point = [200, 100]

    hud_size = 40
    
    self.input = { :escape => :exit, :e => :edit }

    self.viewport.lag = 0.8                         # 0 = no lag, 0.99 = a lot of lag.
    self.viewport.game_area = [0, 0, @game_area[0], @game_area[1]]   # Viewport restrictions, full "game world/map/area"
    
    @file = File.join(ROOT, "levels", self.filename + ".yml")
    load_game_objects(:file => @file)

    @player = Player.create(:x => @spawn_point[0], :y => @spawn_point[1], :zorder => 1000)

    @lives_text = Text.create "Lives:", :x => viewport.x, :y => viewport.y, :size => hud_size
    @score_text = Text.create "Score:", :x => viewport.x + 200, :y => viewport.y, :size => hud_size
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

    @score_text.x = viewport.x + 200
    @score_text.y = viewport.y
    @score_text.text = "Score: #{@player.score}"

    # Die if you fall below the game area
    if @player.y >= viewport.game_area.height
      @player.die!

      if @player.game_over?
        $window.game_over
      else
        @player.warp(spawn_point)
      end
    end

    super
  end
end

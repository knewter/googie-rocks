class GameOver < GameState
  def initialize(options = {})
    super

    PulsatingText.create "You lost!", :x => $window.width / 2, :y => $window.height / 2, :size => 90
  end
end

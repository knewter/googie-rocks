class GameOver < GameState
  def initialize(options = {})
    super

    PulsatingText.create "You lost!", :x => $window.width / 2, :y => $window.height / 2, :size => 90
    Text.create "Press space to try again.", :x => $window.width / 2, :y => $window.height / 2 + 100, :size => 40

    self.input = { :space => Googie.new }
  end
end

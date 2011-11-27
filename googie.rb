require 'gosu'
require 'chipmunk'
require './player'

class GameWindow < Gosu::Window
  WIDTH = 960
  HEIGHT = 662

  def initialize
    super WIDTH, HEIGHT, false
    self.caption = "Googie Look Under Rocks"

    @background_image = Gosu::Image.new(self, "gfx/test-background.jpg", true)
    @player = Player.new(self)
    @player.warp(320, HEIGHT - @player.height)
  end
  
  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.walk_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.walk_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpUp then
      @player.jump
    end
    @player.move
  end
  
  def draw
    @player.draw
    @background_image.draw(0, 0, 0)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show

class Block < GameObject
  trait :bounding_box, :debug => false
  trait :collision_detection
  
  def setup
    @image = Image["#{self.filename}.png"]
  end
  
  def self.solid
    all.select { |block| block.alpha == 255 }
  end
  
  def hit(power)
  end

  def self.inside_viewport
    all.select { |block| block.game_state.viewport.inside?(block) }
  end
end
class GrassBlock < Block; end

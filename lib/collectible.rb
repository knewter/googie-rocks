class Collectible < GameObject
  trait :bounding_box, :debug => false
  trait :collision_detection

  def setup
    @image = Image["#{self.filename}.png"]
  end

  def self.solid
    all.select { |block| block.alpha == 255 }
  end

  # By default, Collectible is worth 1 point. Each subclass should override this for its worth
  def points
    1
  end
end

#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu
include Chingu

require 'ruby-debug'

#
# A minimalistic Chingu example.
# Chingu::Window provides #update and #draw which calls corresponding methods for all objects based on Chingu::Actors
#
# Image["picture.png"] is a deployment safe shortcut to Gosu's Image.new and supports multiple locations for "picture.png"
# By default current dir, media\ and gfx\ is searched. To add own directories:
#
# Image.autoload_dirs << File.join(self.root, "data", "my_image_dir")  
# 
class Game < Chingu::Window
  def initialize
    super(640,480,false)              # leave it blank and it will be 800,600,non fullscreen

    switch_game_state(Googie.new)
    self.input = { :escape => :exit } # exits example on Escape
    
  end
  
  def update
    super
    self.caption = "FPS: #{self.fps} milliseconds_since_last_tick: #{self.milliseconds_since_last_tick}"
  end
end

class Googie < GameState
  # This adds accessor 'viewport' to class and overrides draw() to use it.
  #
  trait :viewport
  
  def initialize(options = {})
    super
    
    self.input = { :escape => :exit, :e => :edit }

    self.viewport.lag = 0                           # 0 = no lag, 0.99 = a lot of lag.
    self.viewport.game_area = [0, 0, 1000, 1000]    # Viewport restrictions, full "game world/map/area"
    
    @file = File.join(ROOT, "levels", self.filename + ".yml")
    load_game_objects(:file => @file)

    @lookup_map = GameObjectMap.new(:game_objects => GrassBlock.all, :grid => [32, 32], :debug => false)

    @player = Player.create(:x => 200, :y => 200, :image => Image["gfx/player.png"])
  end

  def edit
    push_game_state GameStates::Edit.new(:file => @file, :grid => [32,32], :except => [Player], :debug => false)
  end

  def first_terrain_collision(object)
    @lookup_map.from_game_object(object)   if object.collidable
  end

  def update
    off = 200
    self.viewport.x_target = @player.x - $window.width/2 + off
    self.viewport.y_target = @player.y - $window.height/2 - 100

    super
  end
end

class Player < Chingu::GameObject  
  trait :bounding_box, :debug => false
  traits :timer, :collision_detection, :velocity
  attr_accessor :last_x, :last_y, :direction
  
  def setup
    #
    # This shows up the shortened version of input-maps, where each key calls a method of the very same name.
    # Use this by giving an array of symbols to self.input
    #
    self.input = {  [:holding_left, :holding_a] => :move_left, 
                    [:holding_right, :holding_d] => :move_right,
                    [:holding_up, :holding_w] => :jump
                  }
    
    @speed = 3
    @last_x, @last_y = @x, @y
    
    self.acceleration_y = 0.5
    update
  end

  def move(x,y)
    @last_direction = :right if x > 0
    @last_direction = :left if x < 0
    
    @x += x
    @x = @last_x  if self.parent.viewport.outside_game_area?(self)
    
    @y += y
    @y = @last_y  if self.parent.viewport.outside_game_area?(self)

    if game_state.first_terrain_collision(self) or self.x < 1
      @y = @last_y
      self.velocity_y = 0
    end
  end
    
  def move_left
    move(-@speed, 0)
  end

  def move_right
    move(@speed, 0)
  end

  def jump
    move(0, -@speed*3)
  end
  
  # We don't need to call super() in update().
  # By default GameObject#update is empty since it doesn't contain any gamelogic to speak of.
  def update
    if @x == @last_x && @y == @last_y
    else
      # Save the direction to use with bullets when firing
      @direction = [@x - @last_x, @y - @last_y]
    end
    
    @last_x, @last_y = @x, @y
  end
end

class Block < GameObject
  traits :bounding_box, :collision_detection
  
  def setup
    @image = Image["#{self.filename}.png"]
    self.rotation_center = :top_left
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

Game.new.show

#!/usr/bin/env ruby
require 'rubygems' rescue nil
require 'ruby-debug'
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "lib")

require 'chingu'
include Gosu
include Chingu

require 'game'
require 'gameobject_ext'
require 'block'
require 'player'
require 'googie'
require 'game_over'
require 'pulsating_text'

Game.new.show

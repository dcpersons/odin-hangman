# frozen_string_literal: true

require_relative 'lib/game'

puts 'Would you like to play a new game or load a saved game? (new/load)'
response = gets.chomp.downcase
Game.new if response == 'new'
Game.load_game if response == 'load'

# frozen_string_literal: true

require_relative 'lib/game'
loop do
  puts 'Would you like to play a new game, load a saved game, or exit? (new/load/exit)'
  response = gets.chomp.downcase
  case response
  when 'new'
    Game.new_game
  when 'load'
    puts 'You don\'t have any saved games to load.' if Dir.children('./saves').empty?
    Game.load_game unless Dir.children('./saves').empty?
  when 'exit'
    exit
  else
    puts 'Sorry, I didn\'t quite get that.'
  end
end

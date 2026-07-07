# frozen_string_literal: true

require 'yaml'
require_relative 'board'
# For creating games of hangman
class Game
  include Board
  def initialize(word = random_word, guessed = [])
    @word = word
    @guessed = guessed
    @revealed = Array.new(@word.length) { '_' }
    reveal
    @misses = @guessed.length - (@revealed.uniq.length - 1)
    play_game
  end

  def self.new_game
    Game.new
  end

  def self.load_game
    loaded = choose_save
    game = YAML.load_file("./saves/#{loaded}.yml")
    Game.new(game[:word], game[:guessed])
  end

  def self.choose_save
    loaded = loop do
      puts 'Which game would you like to load?'
      Dir.children('./saves').each { |filename| puts filename.split('.').first }
      break loaded if Dir.children('./saves').include?("#{loaded = gets.chomp.downcase}.yml")

      puts 'Sorry, I didn\'t quite get that.'
    end
  end

  private

  def play_game
    status
    until @misses == 7 || @winner
      guess = guess_letter
      return if @saved

      @guessed.push(guess)
      make_guess(guess)
    end
    game_over
  end

  def guess_letter
    loop do
      puts 'Please enter a letter you haven\'t guessed yet, or "save" to save your game.'
      guess = gets.chomp.upcase
      return guess if guess.length == 1 && !@guessed.include?(guess) && guess.match?(/[A-Z]/)

      save if guess == 'SAVE'
      return if @saved

      puts 'Sorry, I didn\'t quite get that.'
      status
    end
  end

  def make_guess(guess)
    if @word.include?(guess)
      hit(guess)
    else
      miss(guess)
    end
    status unless @winner
  end

  def hit(guess)
    puts "The word contains at least one #{guess}!"
    reveal
    @winner = true unless @revealed.include?('_')
  end

  def miss(guess)
    puts "The word does not contain any '#{guess}'s."
    @misses += 1
  end

  def status
    puts board(@misses)
    puts 'Word:'
    puts @revealed.join(' ')
    puts 'Letters you\'ve guessed so far:'
    puts @guessed.sort.join(' ')
  end

  def game_over
    if @winner
      puts board(@misses)
      puts "Congratulations! You found the word '#{@word.downcase}'!"
    else
      puts "Oh dear, you are dead! The word was '#{@word.downcase}'."
    end
  end

  def reveal
    @word.split('').each_with_index do |letter, index|
      @revealed[index] = letter if @guessed.include?(letter)
    end
  end

  def random_word
    File.readlines('./lib/words.txt').filter { |w| w.length >= 6 && w.length <= 13 }.sample.chomp.upcase
  end

  def save
    puts 'What would you like your save to be called?'
    name = gets.chomp.downcase
    file = File.new("saves/#{name}.yml", 'w')
    file.write(YAML.dump({
                           word: @word,
                           guessed: @guessed
                         }))
    @saved = true
    file.fsync
  end
end

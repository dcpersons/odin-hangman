# frozen_string_literal: true

require 'yaml'
require_relative 'board'
# For creating games of hangman
class Game
  include Board
  def initialize(word = random_word.upcase, misses = 0, guessed = [])
    @word = word
    @misses = misses
    @guessed = guessed
    @revealed = Array.new(@word.length) { '_' }
    @winner = false
    play_game
  end

  def self.load_game
    puts 'Which game would you like to load?'
    Dir.foreach('./saves') do |filename|
      puts filename.split('.').first unless ['.', '..'].include?(filename)
    end
    loaded = YAML.load_file("./saves/#{gets.chomp.downcase}.yml")
    new(loaded[:word], loaded[:misses], loaded[:guessed])
  end

  private

  def play_game
    reveal
    status
    until @misses == 7 || @winner
      guess = guess_letter
      @guessed.push(guess)
      make_guess(guess)
    end
    win if @winner
    lose unless @winner
  end

  def guess_letter
    puts 'Please enter a letter you haven\'t guessed yet, or enter "save" to save your game.'
    loop do
      guess = gets.chomp.upcase
      return guess if guess.length == 1 && !@guessed.include?(guess) && guess.match?(/[A-Z]/)

      save if guess == 'SAVE'
      puts 'Sorry, I didn\'t quite get that. Please enter a letter you haven\'t guessed yet.'
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
    board(@misses)
    puts 'Word:'
    puts @revealed.join(' ')
    puts 'Letters you\'ve guessed so far:'
    puts @guessed.sort.join(' ')
  end

  def win
    board(@misses)
    puts "Congratulations! You found the word '#{@word.downcase}'!"
  end

  def lose
    puts "Oh dear, you are dead! The word was '#{@word.downcase}'."
  end

  def random_word
    File.readlines('lib/words.txt').filter { |w| w.length >= 6 && w.length <= 13 }.sample.chomp
  end

  def reveal
    @word.split('').each_with_index do |letter, index|
      @revealed[index] = letter if @guessed.include?(letter)
    end
  end

  def save
    puts 'What would you like your save to be called?'
    name = gets.chomp.downcase
    file = File.new("saves/#{name}.yml", 'w')
    file.write(YAML.dump({
                           word: @word,
                           misses: @misses,
                           revealed: @revealed,
                           guessed: @guessed
                         }))
    exit
  end
end

# frozen_string_literal: true

# Module for printing hangman board
module Board
  def board(misses) # rubocop:disable Metrics/MethodLength
    ['
  +---+
      |
      |
      |
      |
      |
=========', '
  +---+
  |   |
      |
      |
      |
      |
=========', '
  +---+
  |   |
  O   |
      |
      |
      |
=========', '
  +---+
  |   |
  O   |
  |   |
      |
      |
=========', '
  +---+
  |   |
  O   |
 /|   |
      |
      |
=========', '
  +---+
  |   |
  O   |
 /|\  |
      |
      |
=========', '
  +---+
  |   |
  O   |
 /|\  |
 /    |
      |
=========', '
  +---+
  |   |
  O   |
 /|\  |
 / \  |
      |
========='][misses]
  end
end

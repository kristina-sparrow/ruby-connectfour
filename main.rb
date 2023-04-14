# frozen_string_literal: true

require_relative './lib/game'

loop do
  Game.new.play

  puts 'Do you want to play again? (y)'
  print ': '
  choice = gets.chomp
  break unless choice.downcase == 'y'

  system('clear')
end

require './lib/game'
require_relative './lib/setup'

puts "would you like to play against a computer or another human?"
puts "1 for human, 2 for computer"

answer = nil
loop do
	answer = gets.chomp.to_i
	break if [1,2].include? answer
	puts "1 for human, 2 for computer"
end

if answer == 1
	game = Game.new(opponent_type: :human, who_goes_first: :player)
else
	puts "computer"
end

require './lib/game'
require_relative './lib/setup'
include Setup

opponent = Setup.determine_opponent_type
first_player = Setup.determine_first_player

game = Game.new({
		opponent_type: opponent,
		who_goes_first: first_player
	})

Setup.draw_board game.board_matrix

until game.is_over?
	game.play_a_turn
end

Setup.congratulate_winner game

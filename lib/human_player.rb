require_relative "./setup"
include Setup

class	HumanPlayer
	attr_reader :mark, :game

	def initialize(game, mark)
		@game = game
		@mark = mark
	end

	def move
		mark_location = Setup.determine_move mark
		game.mark_board mark_location, mark
	end
end

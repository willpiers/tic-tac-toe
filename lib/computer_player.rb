require_relative './setup'
include Setup

class ComputerPlayer
	attr_reader :mark, :game, :opposing_mark

	ACTIONS = [
		:win,
		:block,
		:random_move,
		:make_fork,
		:block_fork,
		:center,
		:opposite_corner,
		:empty_corner,
		:empty_side
	]

	def initialize game, mark
		@mark = mark
		@game = game
		@opposing_mark = (mark == 'X' ? 'O' : 'X')
	end

	def move
		chosen_move = nil
		ACTIONS.each do |action_title|
			break if chosen_move
			chosen_move = self.send(action_title)
		end
		game.mark_board chosen_move, mark
	end

	def win
		game.get_rows_columns_and_diagonals.each do |line|
			if line.uniq.count == 2 && !line.include?(opposing_mark)
				number = line.find { |entry| entry.is_a? Integer }
				return Setup.translate(number)
			end
		end
		nil
	end

	def block
		game.get_rows_columns_and_diagonals.each do |line|
			if line.uniq.count == 2 && !line.include?(mark)
				number = line.find { |entry| entry.is_a? Integer }
				return Setup.translate(number)
			end
		end
		nil
	end

	def random_move
		space_number = game.available_spaces.sample
		Set.translate(space_number)
	end
end

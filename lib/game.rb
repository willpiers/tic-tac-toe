require_relative './computer_player'
require_relative './human_player'
require_relative './setup'
include Setup

class Game
	attr_accessor :board_matrix, :winner
	attr_reader :who_goes_first, :opponent_type

	def initialize options={}
		@board_matrix = [[1,2,3],[4,5,6],[7,8,9]]
		@winner = nil
		@opponent_type = options[:opponent_type] || :computer
		@who_goes_first = options[:who_goes_first] || :user
		setup_players
	end

	def setup_players
		if opponent_type == :human
			@player1 = HumanPlayer.new(self, 'X')
			@player2 = HumanPlayer.new(self, 'O')
		else
			@player1 = who_goes_first == :user ? HumanPlayer.new(self, 'X') : ComputerPlayer.new(self, 'X')
			@player2 = who_goes_first == :user ? ComputerPlayer.new(self, 'O') : HumanPlayer.new(self, 'O')
		end
	end

	def play_a_round
		@player1.move
		Setup.draw_board @board_matrix
		@player2.move
		Setup.draw_board @board_matrix
	end

	def mark_board location, mark
		@board_matrix[location[:row]][location[:column]] = mark
	end

	def is_over?
		winner = 'X' if check_all_lines('X')
		winner = 'O' if check_all_lines('O')
		all_squares_marked? || winner != nil
	end

	def all_squares_marked?
		@board_matrix.all? do |row|
			row.all? { |entry| entry == 'X' || entry == 'O' }
		end
	end

	def check_all_lines mark
		check_rows(mark) || check_columns(mark) || check_diagonals(mark)
	end

	def check_columns mark
		first = @board_matrix.all? { |row| row.first == mark }
		second = @board_matrix.all? { |row| row[1] == mark }
		third = @board_matrix.all? { |row| row.last == mark }
	end

	def check_rows mark
		@board_matrix.any? do |row|
			row.all? { |entry| entry == mark }
		end
	end

	def check_diagonals mark
		left_to_right = [0,1,2].all? { |index| @board_matrix[index][index] == mark }
		right_to_left = [0,1,2].all? { |index| @board_matrix[index][2-index] == mark }
		left_to_right || right_to_left
	end
end

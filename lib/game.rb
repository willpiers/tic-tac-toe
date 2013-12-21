require_relative './computer_player'
require_relative './human_player'
require_relative './setup'
include Setup

class Game
	attr_accessor :board_matrix, :winner
	attr_reader :who_goes_first, :opponent_type, :next_player

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
		@next_player = @player1
	end

	def play_a_turn
		next_player.move
		Setup.draw_board @board_matrix
		toggle_next_player
	end

	def toggle_next_player
		@next_player = @next_player == @player1 ? @player2 : @player1
	end

	def mark_board location, mark
		@board_matrix[location[:row]][location[:column]] = mark
	end

	def is_over?
		winner = 'X' if check_all_lines('X')
		winner = 'O' if check_all_lines('O')
		all_squares_marked? || !!winner
	end

	def all_squares_marked?
		@board_matrix.all? do |row|
			row.all? { |entry| entry == 'X' || entry == 'O' }
		end
	end

	def check_all_lines mark
		get_rows_columns_and_diagonals.any? do |line|
			line.all? { |entry| entry == mark }
		end
	end

	def get_rows_columns_and_diagonals
		[get_rows, get_columns, get_diagonals].flatten(1)
	end

	def get_rows
		board_matrix
	end

	def get_columns
		first = board_matrix.map { |row| row.first }
		second = board_matrix.map { |row| row[1] }
		third = board_matrix.map { |row| row.last }
		[first, second, third]
	end

	def get_diagonals
		left_to_right = [board_matrix[0][0], board_matrix[1][1], board_matrix[2][2]]
		right_to_left = [board_matrix[0][2], board_matrix[1][1], board_matrix[2][0]]
		[left_to_right, right_to_left]
	end

	def available_spaces
		spaces = []
		board_matrix.each do |row|
			row.each do |entry|
				spaces << entry if entry.is_a? Integer
			end
		end
		spaces
	end
end

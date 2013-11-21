class Game
	attr_accessor :board_matrix

	def initialize options={}
		@board_matrix = [[1,2,3],[4,5,6],[7,8,9]]
		@opponent_type = options[:opponent_type] || :computer
		@who_goes_first = options[:who_goes_first] || :player
	end

	def is_over?
		return 'X' if check_all_lines('X')
		return 'O' if check_all_lines('O')
		false
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
		left_to_right = @board_matrix[0][0] == mark and @board_matrix[1][1] == mark and @board_matrix[2][2] == mark
		right_to_left = @board_matrix[0][2] == mark and @board_matrix[1][1] == mark and @board_matrix[2][0] == mark
		left_to_right || right_to_left
	end
end

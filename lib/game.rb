class Game
	attr_reader :board_matrix

	def initialize options={}
		@board_matrix = [[1,2,3],[4,5,6],[7,8,9]]
		@opponent_type = options[:opponent_type] || :computer
		@who_goes_first = options[:who_goes_first] || :player
	end
end

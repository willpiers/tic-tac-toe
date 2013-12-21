module Setup
	def self.determine_opponent_type
		puts "would you like to play against a friend, or the computer?"

		answer = nil
		until ['1','2'].include? answer
			puts "press 1 for human and 2 for computer."
			answer = accept_input
		end
		answer == '1' ? :human : :computer
	end

	def self.determine_first_player
		puts "who should go first."

		answer = nil
		until ['1','2'].include? answer
			puts "press 1 for you and 2 for other player."
			answer = accept_input
		end
		answer == '1' ? :user : :other
	end

	def self.determine_move mark
		puts "Pick an open square to move"
		puts "You're #{mark}'s, in case you forgot"

		loop do
			mark_location = translate(gets.chomp)
			return mark_location if valid_input?(mark_location)
			puts "Invalid input"
		end
	end

	def self.draw_board board
		system 'clear'
		puts "     |     |      "
		puts "  #{ board[0][0] }  |  #{ board[0][1] }  |  #{ board[0][2] }"
		puts "_____|_____|_____"
		puts "     |     |    "
		puts "  #{ board[1][0] }  |  #{ board[1][1] }  |  #{ board[1][2] }"
		puts "_____|_____|_____"
		puts "     |     |    "
		puts "  #{ board[2][0] }  |  #{ board[2][1] }  |  #{ board[2][2] }"
		puts "     |     |    "
	end

	def self.congratulate_winner game
		winner = game.check_all_lines('X') ? 'X' : 'O'
		puts "good job #{winner}'s"
	end

	def translate mark_location
		return nil unless mark_location
		row = (mark_location.to_f/3.0).ceil - 1
		column = (mark_location.to_i - 1) % 3
		{row: row, column: column}
	end

	private

	def self.accept_input
		gets.chomp
	end

	def valid_input? location
		true
		# TODO this should be based on the current game's board!
	end
end

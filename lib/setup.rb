require 'colorize'

module Setup
	def self.determine_opponent_type
		puts "would you like to play against a friend, or the computer?"

		answer = nil
		until ['1','2'].include? answer
			puts "press 1 for computer and 2 for human."
			answer = accept_input
		end
		answer == '1' ? :computer : :human
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
		colors = color_board(board)
		system 'clear'
		puts "     |     |      "
		puts "  #{ colors[0] }  |  #{ colors[1] }  |  #{ colors[2] }"
		puts "_____|_____|_____"
		puts "     |     |    "
		puts "  #{ colors[3] }  |  #{ colors[4] }  |  #{ colors[5] }"
		puts "_____|_____|_____"
		puts "     |     |    "
		puts "  #{ colors[6] }  |  #{ colors[7] }  |  #{ colors[8] }"
		puts "     |     |    "
	end

	def self.color_board board
		colored_spaces = []
		board.each do |row|
			row.each do |entry|
				if entry.is_a? Integer
					colored_spaces << entry.to_s.colorize(:green)
				elsif entry == 'X'
					colored_spaces << entry.colorize(:blue)
				elsif entry == 'O'
					colored_spaces << entry.colorize(:red)
				end
			end
		end
		colored_spaces
	end

	def self.congratulate_winner game
		winner = 'X' if game.check_all_lines('X')
		winner = 'O' if game.check_all_lines('O')
		message = winner ? "Good job #{winner}'s" : "Cat's game!"
		puts message
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

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
		answer == '1' ? :player1 : :player2
	end

	private

	def self.accept_input
		gets.chomp
	end
end

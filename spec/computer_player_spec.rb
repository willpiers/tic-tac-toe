require_relative '../lib/game'
require_relative '../lib/computer_player'

describe ComputerPlayer do
	it "responds to game and mark" do
		ComputerPlayer.new(Game.new, 'O').should respond_to :mark
		ComputerPlayer.new(Game.new, 'O').should respond_to :game
	end

	describe '#initialize' do
		it "sets the game and mark instance variables" do
		  ComputerPlayer.new(Game.new, 'O').mark.should_not be_nil
		  ComputerPlayer.new(Game.new, 'O').game.should_not be_nil
		end
	end

	describe '#move' do
		context 'when they have a chance to win' do
			# only boards which are one move away from ending
			boards = [
				[['O',2,3],['O',5,6],[7,8,9]],
				[[1,'O',3],[4,'O',6],[7,8,9]],
				[[1,2,'O'],[4,5,'O'],[7,8,9]],
				[[1,2,3],['O',5,6],['O',8,9]],
				[[1,2,3],[4,'O',6],[7,'O',9]],
				[[1,2,3],[4,5,'O'],[7,8,'O']],
				[['O',2,3],[4,5,6],['O',8,9]],
				[[1,'O',3],[4,5,6],[7,'O',9]],
				[[1,2,'O'],[4,5,6],[7,8,'O']],
				[[1,'O','O'],[4,5,6],[7,8,9]],
				[['O','O',3],[4,5,6],[7,8,9]],
				[['O',2,'O'],[4,5,6],[7,8,9]],
				[[1,2,3],[4,'O','O'],[7,8,9]],
				[[1,2,3],['O','O',6],[7,8,9]],
				[[1,2,3],['O',5,'O'],[7,8,9]],
				[[1,2,3],[4,5,6],[7,'O','O']],
				[[1,2,3],[4,5,6],['O','O',9]],
				[[1,2,3],[4,5,6],['O',8,'O']],
				[['O',2,3],[4,'O',6],[7,8,9]],
				[['O',2,3],[4,5,6],[7,8,'O']],
				[[1,2,3],[4,'O',6],[7,8,'O']],
				[[1,2,'O'],[4,'O',6],[7,8,9]],
				[[1,2,'O'],[4,5,6],['O',8,9]],
				[[1,2,3],[4,'O',6],['O',8,9]]
			]
			boards.each do |board|
				it "makes a move which results in the win" do
				  @game = Game.new
				  @game.board_matrix = board
				  @computer_player = ComputerPlayer.new(@game, 'O')

				  @game.is_over?.should be_false
					@computer_player.move
					@game.is_over?.should be_true
				end
			end
		end

		context 'when the other player has 2 in a row with a chance to win' do
			boards = [
				[['O',2,3],['O',5,6],[7,8,9]],
				[[1,'O',3],[4,'O',6],[7,8,9]],
				[[1,2,'O'],[4,5,'O'],[7,8,9]],
				[[1,2,3],['O',5,6],['O',8,9]],
				[[1,2,3],[4,'O',6],[7,'O',9]],
				[[1,2,3],[4,5,'O'],[7,8,'O']],
				[['O',2,3],[4,5,6],['O',8,9]],
				[[1,'O',3],[4,5,6],[7,'O',9]],
				[[1,2,'O'],[4,5,6],[7,8,'O']],
				[[1,'O','O'],[4,5,6],[7,8,9]],
				[['O','O',3],[4,5,6],[7,8,9]],
				[['O',2,'O'],[4,5,6],[7,8,9]],
				[[1,2,3],[4,'O','O'],[7,8,9]],
				[[1,2,3],['O','O',6],[7,8,9]],
				[[1,2,3],['O',5,'O'],[7,8,9]],
				[[1,2,3],[4,5,6],[7,'O','O']],
				[[1,2,3],[4,5,6],['O','O',9]],
				[[1,2,3],[4,5,6],['O',8,'O']],
				[['O',2,3],[4,'O',6],[7,8,9]],
				[['O',2,3],[4,5,6],[7,8,'O']],
				[[1,2,3],[4,'O',6],[7,8,'O']],
				[[1,2,'O'],[4,'O',6],[7,8,9]],
				[[1,2,'O'],[4,5,6],['O',8,9]],
				[[1,2,3],[4,'O',6],['O',8,9]]
			]

			boards.each do |board|
				it "should block the win" do
				  @game = Game.new
				  @game.board_matrix = board
				  @computer_player = ComputerPlayer.new(@game, 'X')
				  @opponent = ComputerPlayer.new(@game, 'O')

					@computer_player.move
					@opponent.move
					@game.is_over?.should be_false
				end
			end
		end
	end
end

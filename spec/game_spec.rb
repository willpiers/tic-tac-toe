require_relative '../lib/game'

describe Game do
	before(:each) do
		@game = Game.new
	end

	it "responds to board_matrix" do
	  Game.new.should respond_to :board_matrix
	end

	describe '#initialize' do
		it "sets up the board_matrix" do
			starting_matrix = [[1,2,3],[4,5,6],[7,8,9]]
		  Game.new.board_matrix.should eq starting_matrix
		end
	end

	describe '#is_over?' do
		describe 'when neither player has won' do
			it "returns false" do
				@game.is_over?.should be_false
			end
		end

		it "returns true when there are 3 X's veritcally" do
			@game.board_matrix = [['unimportant', nil, 'X',],[2,'hello','X'],['O','X','X']]
			@game.is_over?.should be_true
		end
	end

	describe '#check_rows' do
		describe 'when there are three of the same mark in a row' do
			it "returns something truthy" do
			  @game.board_matrix = [[1,2,3],['X','X','X'],['a','b',50]]
			  @game.check_rows('X').should be_true
			end
		end

		describe 'when there are no rows with all the same mark' do
			it "returns something falsy" do
				@game.check_rows('X').should be_false
				@game.check_rows('O').should be_false
			end
		end
	end

	describe '#check_columns' do
		describe 'when there are three of the same mark in the first column' do
			it "returns true" do
				@game.board_matrix = [[1,2,'O'],[4,5,'O'],[7,8,'O']]
			  @game.check_columns('O').should be_true
			end
		end

		describe 'when there are three of the same mark in the second column' do
			it "returns a truthy value" do
			  @game.board_matrix = [[1,'X','hello'],[2,'X',nil],['X','X','O']]
			  @game.check_columns('X').should be_true
			end
		end

		describe 'when there are three of the same mark in the third column' do
			it "returns a truthy value" do
			  @game.board_matrix = [['X',2,'hello'],['X',5,'world'],['X',8,'O']]
			  @game.check_columns('X').should be_true
			end
		end

		describe 'when there are no columns with three of the same mark' do
			it "returns a falsy value" do
			 	@game.board_matrix = [[nil, false, true],['hello',true,'Dexter'],['the','assassin',40]]
			 	@game.check_columns('X').should be_false
			 	@game.check_columns('O').should be_false
			end
		end
	end
end

require_relative '../lib/game'

describe Game do
	it "responds to board_matrix" do
	  Game.new.should respond_to :board_matrix
	end

	describe '#initialize' do
		it "sets up the board_matrix" do
			proper_matrix = [[1,2,3],[4,5,6],[7,8,9]]
		  Game.new.board_matrix.should eq proper_matrix
		end
	end

	describe '#is_over?' do
		before(:each) do
			@game = Game.new
		end

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
		before(:each) do
			@game = Game.new
		end

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
end

require_relative '../lib/game'

describe Game do
	it "responds to board_matrix" do
	  Game.new.should respond_to :board_matrix
	end

	describe '#initialize' do
		it "should set up the board_matrix" do
			proper_matrix = [[1,2,3],[4,5,6],[7,8,9]]
		  Game.new.board_matrix.should eq proper_matrix
		end
	end
end

require 'game'
require 'spec_helper'

describe Game do
  before(:each) do
    @game = Game.new
  end

  it "responds to board" do
    expect(Game.new).to respond_to :board
  end

  describe '#initialize' do
    it "sets up the board_matrix" do
      starting_matrix = [[1,2,3],[4,5,6],[7,8,9]]
      expect(Game.new.board.cells).to eq starting_matrix
    end
  end

  describe '#is_over?' do
    describe 'when neither player has won' do
      it "returns false" do
        expect(@game.is_over?).to be_false
      end
    end

    it "returns true when there are 3 X's veritcally" do
      @game.board = Board.new [['unimportant', nil, 'X',],[2,'hello','X'],['O','X','X']]
      expect(@game.is_over?).to be_true
    end
  end
end

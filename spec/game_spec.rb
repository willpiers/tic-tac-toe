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
      expect(Game.new.board).to eq starting_matrix
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

  describe '#available_spaces' do
    context "when no moves have been made" do
      it "returns a flat array with all board spaces" do
        @game.board = Board.new [[1,2,3],[4,5,6],[7,8,9]]
        expect(@game.board.available_spaces).to eq [1,2,3,4,5,6,7,8,9]
      end
    end

    context "when some moves have been made" do
      it "returns an array of space numbers" do
        @game.board = Board.new [[1,2,'O'],['X',5,'O'],['X',8,9]]
        expect(@game.board.available_spaces).to eq [1,2,5,8,9]
      end
    end

    context "when the board is filled" do
      it "renturns an empty array" do
        @game.board = Board.new [['O','X','O'],['X','X','O'],['X','O','X']]
        expect(@game.board.available_spaces).to eq []
      end
    end
  end
end

require 'board'
require 'spec_helper'

describe Board do
  describe '#available_spaces' do
    context "when no moves have been made" do
      it "returns a flat array with all board spaces" do
        board = Board.new [[1,2,3],[4,5,6],[7,8,9]]
        expect(board.available_spaces).to eq [1,2,3,4,5,6,7,8,9]
      end
    end

    context "when some moves have been made" do
      it "returns an array of space numbers" do
        board = Board.new [[1,2,'O'],['X',5,'O'],['X',8,9]]
        expect(board.available_spaces).to eq [1,2,5,8,9]
      end
    end

    context "when the board is filled" do
      it "renturns an empty array" do
        board = Board.new [['O','X','O'],['X','X','O'],['X','O','X']]
        expect(board.available_spaces).to eq []
      end
    end
  end

  describe '#full?' do
    context 'when all squares are marked' do
      it 'is truthy' do
        board = Board.new [['O','X','X'],['X','X','O'],['X','O','X']]
        expect(board.full?).to be_true
      end
    end

    context 'when some squares are not marked' do
      it 'is falsy' do
        board = Board.new [[1,2,3],['O','X','O'],['X','O','X']]
        expect(board.full?).to be_false
      end
    end
  end
end

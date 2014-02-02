require 'board'
require 'spec_helper'

describe Board do
  describe '#value_at' do
    before do
      @board = Board.new [['X',2,3],[4,'O',6],['this too!',8,9]]
    end
    it 'returns the value at the given location' do
      expect(@board.value_at({row: 0, column: 0})).to eq 'X'
    end

    it "does't care if the value is a single character" do
      expect(@board.value_at({row: 2, column: 0})).to eq 'this too!'
    end
  end

  describe '#available_spaces' do
    context "when no moves have been made" do
      it "returns a flat array with all board spaces" do
        board = Board.new [[1,2,3],[4,5,6],[7,8,9]]
        expected = (1..9).map { |index| Board.to_coordinates index }
        expect(board.available_spaces).to eq expected
      end
    end

    context "when some moves have been made" do
      it "returns an array of space numbers" do
        board = Board.new [[1,2,'O'],['X',5,'O'],['X',8,9]]
        expected = [1,2,5,8,9].map { |index| Board.to_coordinates index }
        expect(board.available_spaces).to eq expected
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

  describe '.to_coordinates' do
    it "translates an integer into a hash with a row and column" do
      expected = {row: 1, column: 2}
      expect(Board.to_coordinates(6)).to eq expected
    end
  end
end

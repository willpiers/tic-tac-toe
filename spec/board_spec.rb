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

  describe '.valid_input?' do
    context "when given text instead of an integer" do
      it "returns false" do
        blank_board = Game.new.board
        actual = blank_board.valid_input? 'hello world'
        expect(actual).to be_false
      end
    end

    context "when given a location that is already occupied" do
      it "returns false" do
        game = Game.new
        game.board = Board.new [['X',2,3],[4,5,6],[7,8,9]]
        expect(game.board.valid_input?(1)).to be_false
      end
    end

    context "when given an integer <1 or >9" do
      it "returns false" do
        blank_board = Game.new.board
        expect(blank_board.valid_input?(0)).to be_false
        expect(blank_board.valid_input?(50)).to be_false
      end
    end

    context "when given an integer >0 and <10" do
      it "returns true" do
        blank_board = Game.new.board
        expect(blank_board.valid_input?(1)).to be_true
        expect(blank_board.valid_input?(9)).to be_true
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

require 'game'
require 'ttt_io'
require 'spec_helper'

describe ComputerPlayer do
  it "responds to game and mark" do
    expect(ComputerPlayer.new(Game.new, 'O')).to respond_to :mark
    expect(ComputerPlayer.new(Game.new, 'O')).to respond_to :game
  end

  describe '#initialize' do
    it "sets the game and mark instance variables" do
      expect(ComputerPlayer.new(Game.new, 'O').mark).to_not be_nil
      expect(ComputerPlayer.new(Game.new, 'O').game).to_not be_nil
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
          game = Game.new
          game.board = Board.new board
          computer_player = ComputerPlayer.new(game, 'O')

          expect(game.is_over?).to be_false
          computer_player.move
          expect(game.is_over?).to be_true
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
        it "blocks the win" do
          game = Game.new
          game.board = Board.new board
          computer_player = ComputerPlayer.new(game, 'X')
          opponent = ComputerPlayer.new(game, 'O')

          computer_player.move
          opponent.move
          expect(game.is_over?).to be_false
        end
      end
    end

    context "when there is a chance to make a fork" do
      boards = [
        [['O','X','O'],[4,5,6],[7,8,9]],
        [[1,2,3],[4,5,6],['O','X','O']],
        [[1,2,'O'],[4,'X',6],['O',8,'X']]
      ]

      boards.each do |board|
        it "makes a fork" do
          game = Game.new
          game.board = Board.new board
          computer_player = ComputerPlayer.new(game, 'O')
          opponent = ComputerPlayer.new(game, 'X')

          computer_player.move
          opponent.move
          computer_player.move
          expect(game.is_over?).to be_true
        end
      end
    end
  end

  describe '#empty_side' do
    before(:each) do
      @game = Game.new
      @computer_player = ComputerPlayer.new(@game, 'X')
      @computer_player.stub(:strategies).and_return([:empty_side])
    end
    it "returns a move hash when one is available" do
      @game.board = Board.new [[1,'O',3],['O',5,6],[7,'O',9]]
      expect(@computer_player.determine_move).to eq({row: 1, column: 2})
    end

    it "returns nil when there are no sides available" do
      @game.board = Board.new [[1,'O',3],['O',5,'X'],[7,'O',9]]
      expect(@computer_player.determine_move).to_not be_a Hash
    end
  end

  describe '#empty_corner' do
    before(:each) do
      @game = Game.new
      @computer_player = ComputerPlayer.new(@game, 'X')
      @computer_player.stub(:strategies).and_return([:empty_corner])
    end
    it "returns a move hash when one is available" do
      @game.board = Board.new [['X',2,'O'],[4,5,6],['O',8,9]]
      expect(@computer_player.determine_move).to eq({row: 2, column: 2})
    end

    it "returns nil when there are no corners available" do
      @game.board = Board.new [['X','O','X'],['O',5,'X'],['X','O','O']]
      expect(@computer_player.determine_move).to_not be_a Hash
    end
  end

  describe '#opposite_corner' do
    before(:each) do
      @game = Game.new
      @player = ComputerPlayer.new(@game, 'X')
      @player.stub(:strategies).and_return([:opposite_corner])
    end

    context 'when the top left corner is occupied' do
      before do
        @game.board = Board.new [['O',2,3],[4,5,6],[7,8,9]]
      end

      it 'moves in the bottom right corner' do
        @player.move
        expect(@game.board.cells).to eq [['O',2,3],[4,5,6],[7,8,'X']]
      end
    end

    context 'when the top right corner is occupied' do
      before do
        @game.board = Board.new [[1,2,'O'],[4,5,6],[7,8,9]]
      end

      it 'moves in the bottom left corner' do
        @player.move
        expect(@game.board.cells).to eq [[1,2,'O'],[4,5,6],['X',8,9]]
      end
    end

    context 'when the bottom left corner is occupied' do
      before do
        @game.board = Board.new [[1,2,3],[4,5,6],['O',8,9]]
      end

      it 'moves in the top right corner' do
        @player.move
        expect(@game.board.cells).to eq [[1,2,'X'],[4,5,6],['O',8,9]]
      end
    end

    context 'when the bottom right corner is occupied' do
      before do
        @game.board = Board.new [[1,2,3],[4,5,6],[7,8,'O']]
      end

      it 'moves in the top left corner' do
        @player.move
        expect(@game.board.cells).to eq [['X',2,3],[4,5,6],[7,8,'O']]
      end
    end
  end

  describe '#center' do
    before(:each) do
      @game = Game.new
      @game.board = Board.new [[1,2,3],[4,5,6],[7,8,9]]
      @player = ComputerPlayer.new(@game, 'X')
      @player.stub(:strategies).and_return([:center])
    end

    context 'when the center is available' do
      it "marks the center square" do
        @player.move
        expect(@game.board.cells).to eq [[1,2,3],[4,'X',6],[7,8,9]]
      end
    end

    context 'when the center is marked' do
      it "returns nil" do
        @game.board.mark({row: 1, column: 1}, 'O')
        expect(@player.determine_move).to_not eq({row: 1, column: 1})
      end
    end
  end

  describe '#block_fork_directly' do
    it 'blocks moves in a spot to block the fork immediately' do
      game = Game.new
      game.board = Board.new [[1,'O',3],[4,'X','O'],[7,8,9]] #just one case. could be much better. TODO
      player = ComputerPlayer.new(game, 'X')
      player.stub(:strategies).and_return([:block_fork_directly])
      player.move
      expect(game.board.cells).to eq [[1,'O','X'],[4,'X','O'],[7,8,9]]
    end
  end
end

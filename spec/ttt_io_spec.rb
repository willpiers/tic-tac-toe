require 'spec_helper'

describe TttIO do
  it "has methods for ascertaining opponent type and who goes first" do
    expect(TttIO).to respond_to :determine_opponent_type
    expect(TttIO).to respond_to :determine_first_player
  end

  describe ".determine_first_player" do
    it "asks user who they want to play first" do
      TttIO.stub(:accept_input).and_return('1')

      output = capture_stdout { TttIO.determine_first_player }
      expect(output).to eq "who should go first?\npress 1 for you, and 2 for the other player.\n"
    end

    describe "when user responds with 1" do
      before do
        TttIO.stub(:accept_input).and_return('1')
      end

      it "returns a symbol" do
        capture_stdout do
          actual = TttIO.determine_first_player
          expect(actual).to be_a Symbol
        end
      end

      it "returns the correct player" do
        capture_stdout do
          expect(TttIO.determine_first_player).to eq :user
        end
      end
    end
  end

  describe '.determine_opponent_type' do
    it "asks user if they'd like to play against another human or CPU" do
      TttIO.stub(:accept_input).and_return('1')

      output = capture_stdout { TttIO.determine_opponent_type }
      expect(output).to eq "would you like to play against a friend, or the computer?\npress 1 for computer, and 2 for human.\n"
    end
  end

  describe '.determine_user_move' do
    it "prompts user to enter a move" do
      TttIO.stub(:accept_input).and_return('5')
      output = capture_stdout { TttIO.determine_user_move(Game.new.board, 'X') }
      expect(output).to eq "Pick an open square to move.\nYou're X's, in case you forgot.\n"
    end
  end

  describe '.draw_board' do
    it 'draws the board to stdout' do
      board = Board.new [[1,2,3],[4,5,6],[7,8,9]]
      TttIO.stub(:clear_screen)
      output = capture_stdout { TttIO.draw board }
      expect(output).to eq "     |     |      \n  1  |  2  |  3\n_____|_____|_____\n     |     |    \n  4  |  5  |  6\n_____|_____|_____\n     |     |    \n  7  |  8  |  9\n     |     |    \n"
    end
  end

  describe '.congratulate_winner' do
    context 'when there is a winner' do
      before do
        @game = Game.new
        @game.board.stub(:check_all_lines).with('X').and_return true
        @game.board.stub(:check_all_lines).with('O').and_return false
      end

      it 'congratulates the winner' do
        output = capture_stdout { TttIO.congratulate_winner @game }
        expect(output).to eq "Good job X's\n"
      end
    end

    context "when it is a cat's game" do
      before do
        @game = Game.new
        @game.board.stub(:check_all_lines).and_return false
      end

      it "tells players that the game is a cat's game" do
        output = capture_stdout { TttIO.congratulate_winner @game }
        expect(output).to eq "Cat's game!\n"
      end
    end
  end
end



def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end

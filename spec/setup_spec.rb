require_relative '../lib/setup'
include Setup

describe Setup do
  it "has methods for ascertaining opponent type and who goes first" do
    expect(Setup).to respond_to :determine_opponent_type
    expect(Setup).to respond_to :determine_first_player
  end

  describe ".determine_first_player" do
    it "asks user who they want to play first" do
      Setup.stub(:accept_input).and_return('1')

      output = capture_stdout { Setup.determine_first_player }
      expect(output).to eq "who should go first?\npress 1 for you, and 2 for the other player.\n"
    end

    describe "when user responds with 1" do
      before do
        Setup.stub(:accept_input).and_return('1')
      end

      it "returns a symbol" do
        capture_stdout do
          actual = Setup.determine_first_player
          expect(actual).to be_a Symbol
        end
      end

      it "returns the correct player" do
        capture_stdout do
          expect(Setup.determine_first_player).to eq :user
        end
      end
    end
  end

  describe '.determine_opponent_type' do
    it "asks user if they'd like to play against another human or CPU" do
      Setup.stub(:accept_input).and_return('1')

      output = capture_stdout { Setup.determine_opponent_type }
      expect(output).to eq "would you like to play against a friend, or the computer?\npress 1 for computer, and 2 for human.\n"
    end
  end

  describe '.translate' do
    it "translates an integer into a hash with a row and column" do
      expected = {row: 1, column: 2}
      expect(Setup.translate(6)).to eq expected
    end
  end

  describe '.valid_input?' do
    context "when given text instead of an integer" do
      it "returns false" do
        actual = Setup.valid_input? Game.new, 'hello world'
        expect(actual).to be_false
      end
    end

    context "when given a location that is already occupied" do
      it "returns false" do
        game = Game.new
        game.board_matrix = [['X',2,3],[4,5,6],[7,8,9]]
        expect(Setup.valid_input?(game, 1)).to be_false
      end
    end

    context "when given an integer <1 or >9" do
      it "returns false" do
        expect(Setup.valid_input?(Game.new, 0)).to be_false
        expect(Setup.valid_input?(Game.new, 50)).to be_false
      end
    end

    context "when given an integer >0 and <10" do
      it "returns true" do
        expect(Setup.valid_input?(Game.new, 1)).to be_true
        expect(Setup.valid_input?(Game.new, 9)).to be_true
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

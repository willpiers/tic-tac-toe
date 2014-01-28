require 'game'
require 'spec_helper'

describe HumanPlayer do
  before(:each) do
    @game = Game.new
    @player = HumanPlayer.new(@game, 'X')
  end

  it "has a game and a mark" do
    expect(@player.game).to eq @game
    expect(@player.mark).to eq 'X'
  end

  describe '#move' do
    it "marks the board according to the user's choice of move" do
      Setup.stub(:accept_input).and_return('5')
      output = capture_stdout { @player.move }
      expect(@game.board).to eq Board.new([[1,2,3],[4,'X',6],[7,8,9]])
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

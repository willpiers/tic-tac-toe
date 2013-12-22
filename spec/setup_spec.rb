require_relative '../lib/setup'
include Setup

describe Setup do
	it "has methods for ascertaining opponent type and who goes first" do
	  Setup.should respond_to :determine_opponent_type
	  Setup.should respond_to :determine_first_player
	end

	describe ".determine_first_player" do
		it "asks user who they want to play first" do
			Setup.stub(:accept_input).and_return('1')

			output = capture_stdout { Setup.determine_first_player }
			output.should == "who should go first.\npress 1 for you and 2 for other player.\n"
		end

		describe "when user responds with 1" do
			before do
				Setup.stub(:accept_input).and_return('1')
			end

			it "returns a symbol" do
			  capture_stdout do
			  	actual = Setup.determine_first_player
				  actual.should be_a Symbol
			  end
			end

			it "returns the correct player" do
			  capture_stdout do
			  	Setup.determine_first_player.should == :user
			  end
			end
		end
	end

	describe '.determine_opponent_type' do
		it "asks user if they'd like to play against another human or CPU" do
		  Setup.stub(:accept_input).and_return('1')

		  output = capture_stdout { Setup.determine_opponent_type }
		  output.should == "would you like to play against a friend, or the computer?\npress 1 for computer and 2 for human.\n"
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

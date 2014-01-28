$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/lib")

require 'setup'
require 'game'
include Setup

game = Game.new({
  opponent_type: Setup.determine_opponent_type,
  who_goes_first: Setup.determine_first_player
})

game.board.draw

until game.is_over?
  game.play_a_turn
end

Setup.congratulate_winner game

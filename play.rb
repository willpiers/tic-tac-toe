$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/lib")

require 'ttt_io'
require 'game'

game = Game.new({
  opponent_type: TttIO.determine_opponent_type,
  who_goes_first: TttIO.determine_first_player
})

TttIO.draw game.board

until game.is_over?
  game.play_a_turn
end

TttIO.congratulate_winner game

require './lib/game'
require './lib/setup'
require './lib/board'
include Setup


game = Game.new({
  opponent_type: Setup.determine_opponent_type,
  who_goes_first: Setup.determine_first_player
})

Setup.draw_board game.board

until game.is_over?
  game.play_a_turn
end

Setup.congratulate_winner game

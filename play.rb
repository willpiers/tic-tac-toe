require './lib/game'
require './lib/setup'
include Setup


game = Game.new({
  opponent_type: Setup.determine_opponent_type,
  who_goes_first: Setup.determine_first_player
})

Setup.draw_board game.board_matrix

until game.is_over?
  game.play_a_turn
end

Setup.congratulate_winner game

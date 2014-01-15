class HumanPlayer
  attr_reader :mark, :game

  def initialize(game, mark)
    @game = game
    @mark = mark
  end

  def move
    mark_location = Setup.determine_user_move(game, mark)
    game.mark_board mark_location, mark
  end
end

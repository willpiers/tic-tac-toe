class HumanPlayer
  attr_reader :mark, :game

  def initialize(game, mark)
    @game = game
    @mark = mark
  end

  def move
    mark_location = TttIO.determine_user_move(game, mark)
    game.board.mark mark_location, mark
  end
end

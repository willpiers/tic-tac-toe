require 'board'
require 'human_player'
require 'computer_player'

class Game
  attr_accessor :board
  attr_reader :who_goes_first, :opponent_type, :next_player, :winner

  def initialize options={}
    @board = Board.new [[1,2,3],[4,5,6],[7,8,9]], {x: 'X', o: 'O'}
    @winner = nil
    @opponent_type = options[:opponent_type] || :computer
    @who_goes_first = options[:who_goes_first] || :user
    setup_players
  end

  def setup_players
    if opponent_type == :human
      @player1 = HumanPlayer.new(self, board.x_marker)
      @player2 = HumanPlayer.new(self, board.o_marker)
    else
      @player1 = who_goes_first == :user ? HumanPlayer.new(self, board.x_marker) : ComputerPlayer.new(self, board.x_marker)
      @player2 = who_goes_first == :user ? ComputerPlayer.new(self, board.o_marker) : HumanPlayer.new(self, board.o_marker)
    end
    @next_player = @player1
  end

  def play_a_turn
    next_player.move
    TttIO.draw board
    toggle_next_player
  end

  def is_over?
    @winner = board.x_marker if board.check_all_lines(board.x_marker)
    @winner = board.o_marker if board.check_all_lines(board.o_marker)
    board.full? || !!@winner || impossible_to_win?
  end

  private

  def toggle_next_player
    @next_player = @next_player == @player1 ? @player2 : @player1
  end

  def impossible_to_win?
    board.all_lines.all? do |line|
      values = board.values_at line
      values.include?(board.x_marker) && values.include?(board.o_marker)
    end
  end
end

require 'board'
require 'human_player'
require 'computer_player'

class Game
  attr_accessor :board
  attr_reader :who_goes_first, :opponent_type, :next_player, :winner

  def initialize options={}
    @board = Board.new [[1,2,3],[4,5,6],[7,8,9]]
    @winner = nil
    @opponent_type = options[:opponent_type] || :computer
    @who_goes_first = options[:who_goes_first] || :user
    setup_players
  end

  def setup_players
    if opponent_type == :human
      @player1 = HumanPlayer.new(self, 'X')
      @player2 = HumanPlayer.new(self, 'O')
    else
      @player1 = who_goes_first == :user ? HumanPlayer.new(self, 'X') : ComputerPlayer.new(self, 'X')
      @player2 = who_goes_first == :user ? ComputerPlayer.new(self, 'O') : HumanPlayer.new(self, 'O')
    end
    @next_player = @player1
  end

  def play_a_turn
    next_player.move
    board.draw
    toggle_next_player
  end

  def toggle_next_player
    @next_player = @next_player == @player1 ? @player2 : @player1
  end

  def mark_board location, mark
    board[location[:row]][location[:column]] = mark
  end

  def is_over?
    @winner = 'X' if board.check_all_lines('X')
    @winner = 'O' if board.check_all_lines('O')
    board.all_squares_marked? || !!@winner || board.impossible_to_win?
  end
end

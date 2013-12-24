require_relative './computer_player'
require_relative './human_player'
require_relative './setup'
include Setup

class Game
  attr_accessor :board_matrix
  attr_reader :who_goes_first, :opponent_type, :next_player, :winner

  def initialize options={}
    @board_matrix = [[1,2,3],[4,5,6],[7,8,9]]
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
    Setup.draw_board @board_matrix
    toggle_next_player
  end

  def toggle_next_player
    @next_player = @next_player == @player1 ? @player2 : @player1
  end

  def mark_board location, mark
    board_matrix[location[:row]][location[:column]] = mark
  end

  def is_over?
    @winner = 'X' if check_all_lines('X')
    @winner = 'O' if check_all_lines('O')
    all_squares_marked? || !!@winner
  end

  def all_squares_marked?
    board_matrix.all? do |row|
      row.all? { |entry| entry == 'X' || entry == 'O' }
    end
  end

  def check_all_lines mark
    get_rows_columns_and_diagonals.any? do |line|
      line.all? { |entry| entry == mark }
    end
  end

  def get_rows_columns_and_diagonals; [get_rows, get_columns, get_diagonals].flatten(1); end
  def get_rows; board_matrix; end
  def get_columns; [column(0),column(1),column(2)]; end

  def row row_number
    raise(ArgumentError, 'Invalid column number given') if row_number > 2 or row_number < 0
    board_matrix[row_number]
  end

  def column col_number
    raise(ArgumentError, 'Invalid column number given') if col_number > 2 or col_number < 0
    board_matrix.map { |row| row[col_number] }
  end

  def corners
    [board_matrix[0][0], board_matrix[0][2], board_matrix[2][0], board_matrix[2][2]]
  end

  def edges
    [board_matrix[0][1], board_matrix[1][0], board_matrix[1][2], board_matrix[2][1]]
  end

  def get_diagonals
    left_to_right = [board_matrix[0][0], board_matrix[1][1], board_matrix[2][2]]
    right_to_left = [board_matrix[0][2], board_matrix[1][1], board_matrix[2][0]]
    [left_to_right, right_to_left]
  end

  def available_spaces
    board_matrix.flatten.select { |entry| entry.is_a? Integer }
  end

  def intersecting_lines
    [
      {first: row(0), second: column(0), space: 1},
      {first: row(0), second: column(1), space: 2},
      {first: row(0), second: column(2), space: 3},
      {first: row(1), second: column(0), space: 4},
      {first: row(1), second: column(1), space: 5},
      {first: row(1), second: column(2), space: 6},
      {first: row(2), second: column(0), space: 7},
      {first: row(2), second: column(1), space: 8},
      {first: row(2), second: column(2), space: 9},
      {first: get_diagonals.first, second: get_diagonals.last, space: 5},
      {first: row(0), second: get_diagonals.first, space: 1},
      {first: row(1), second: get_diagonals.first, space: 5},
      {first: row(2), second: get_diagonals.first, space: 9},
      {first: column(0), second: get_diagonals.first, space: 1},
      {first: column(1), second: get_diagonals.first, space: 5},
      {first: column(2), second: get_diagonals.first, space: 9},
      {first: row(0), second: get_diagonals.last, space: 3},
      {first: row(1), second: get_diagonals.last, space: 5},
      {first: row(2), second: get_diagonals.last, space: 7},
      {first: column(0), second: get_diagonals.last, space: 7},
      {first: column(1), second: get_diagonals.last, space: 5},
      {first: column(2), second: get_diagonals.last, space: 3}
    ]
  end
end

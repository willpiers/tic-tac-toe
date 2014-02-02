require 'colorize'

class Board < Array
  attr_reader :x_marker, :o_marker, :board_size

  def initialize ary, markers={}
    super ary
    @x_marker = markers[:x] || 'X'
    @o_marker = markers[:o] || 'O'
    @board_size = 3
  end

  def mark location, marker
    self[location[:row]][location[:column]] = marker
  end

  def value_at location
    self[location[:row]][location[:column]]
  end

  def values_at locations
    locations.map do |location|
      value_at location
    end
  end

  def full?
    flatten.all? { |entry| entry == x_marker || entry == o_marker }
  end

  def available? location
    if location.is_a?(Hash)
      self[location[:row]][location[:column]].is_a?(Integer)
    elsif location.is_a?(Integer)
      flatten.include?(location)
    else
      false
    end
  end

  def self.to_coordinates mark_location
    return nil unless mark_location
    row = (mark_location.to_f/3.0).ceil - 1
    column = (mark_location - 1) % 3
    {row: row, column: column}
  end

  def check_all_lines mark
    all_lines.any? do |line|
      line.all? { |location| value_at(location) == mark }
    end
  end

  def all_lines; [get_rows, get_columns, get_diagonals].flatten(1); end
  def get_rows; [row(0),row(1),row(2)]; end
  def get_columns; [column(0),column(1),column(2)]; end

  def row row_number
    (0...board_size).map { |col_number| {row: row_number, column: col_number} }
  end

  def column col_number
    (0...board_size).map { |row_number| {row: row_number, column: col_number} }
  end

  def corners
    [
      {row: 0, column: 0},
      {row: 0, column: 2},
      {row: 2, column: 0},
      {row: 2, column: 2}
    ]
  end

  def edges
    [
      {row: 0, column: 1},
      {row: 1, column: 0},
      {row: 1, column: 2},
      {row: 2, column: 1}
    ]
  end

  def get_diagonals
    center = Board.to_coordinates(5)
    left_to_right = [Board.to_coordinates(1), center, Board.to_coordinates(9)]
    right_to_left = [Board.to_coordinates(3), center, Board.to_coordinates(7)]
    [left_to_right, right_to_left]
  end

  def available_spaces
    flatten.select { |entry| entry.is_a? Integer }.map { |index| Board.to_coordinates(index) }
  end

  def intersections
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

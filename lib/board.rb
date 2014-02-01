require 'colorize'

class Board < Array
  attr_reader :x_marker, :o_marker

  def initialize ary, markers={}
    super ary
    @x_marker = markers[:x] || 'X'
    @o_marker = markers[:o] || 'O'
  end

  def mark location, marker
    self[location[:row]][location[:column]] = marker
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
      line.all? { |entry| entry == mark }
    end
  end

  def all_lines; [get_rows, get_columns, get_diagonals].flatten(1); end
  def get_rows; self; end
  def get_columns; [column(0),column(1),column(2)]; end

  def row row_number
    self[row_number]
  end

  def column col_number
    map { |row| row[col_number] }
  end

  def corners
    [
      {row: 0, column: 0, val: self[0][0]},
      {row: 0, column: 2, val: self[0][2]},
      {row: 2, column: 0, val: self[2][0]},
      {row: 2, column: 2, val: self[2][2]}
    ]
  end

  def edges
    [
      {row: 0, column: 1, val: self[0][1]},
      {row: 1, column: 0, val: self[1][0]},
      {row: 1, column: 2, val: self[1][2]},
      {row: 2, column: 1, val: self[2][1]}
    ]
  end

  def get_diagonals
    left_to_right = [self[0][0], self[1][1], self[2][2]]
    right_to_left = [self[0][2], self[1][1], self[2][0]]
    [left_to_right, right_to_left]
  end

  def available_spaces
    flatten.select { |entry| entry.is_a? Integer }
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

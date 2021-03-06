require 'game'
require 'board'

class ComputerPlayer
  attr_reader :mark, :game, :opposing_mark

  def initialize game, mark
    @mark = mark
    @game = game
    @opposing_mark = other_mark(mark)
  end

  def board
    game.board
  end

  def strategies
    [
      :win,
      :block,
      :make_fork,
      :block_fork_indirectly,
      :block_fork_directly,
      :center,
      :opposite_corner,
      :empty_corner,
      :empty_side,
    ]
  end

  def move
    board.mark determine_move, mark
  end

  def determine_move
    strategies.each do |strategy|
      chosen_move = self.send(strategy)
      return chosen_move if chosen_move
    end
  end

  def other_mark mark
    mark == game.board.x_marker ? game.board.o_marker : game.board.x_marker
  end

  def forks
    board.intersections.select do |junction|
      fork_possible?(junction, mark) && board.available?(junction[:space])
    end.map { |junction| Board.to_coordinates junction[:space] }
  end

  private

  def win; complete_line(mark); end
  def block; complete_line(opposing_mark); end

  def complete_line the_mark
    close_line = board.all_lines.find { |line| two_in_a_row?(line, other_mark(the_mark)) } || []
    close_line.find { |location| board.value_at(location).is_a? Integer }
  end

  def two_in_a_row? line, mark
    values = board.values_at line
    values.uniq.count == 2 && !values.include?(mark)
  end

  def make_fork; forks.sample; end

  def block_fork_indirectly
    board.all_lines.shuffle.each do |line|
      if board.values_at(line).include?(mark) && !board.values_at(line).include?(opposing_mark)
        possible_choices = line & board.available_spaces
        possible_choices.each do |location|
          fake_game = Game.new
          fake_opponent = ComputerPlayer.new(fake_game, opposing_mark)

          fake_game.board = Marshal.load( Marshal.dump( board ) )
          fake_game.board.mark location, mark

          unless fake_opponent.forks.any? { |fork| fork == fake_opponent.send(:block) }
            return location
          end
        end
      end
    end
    nil
  end

  def block_fork_directly
    board.intersections.shuffle.each do |intersection|
      if fork_possible?(intersection, opposing_mark)
        if board.available?(intersection[:space])
          return Board.to_coordinates(intersection[:space])
        end
      end
    end
    nil
  end

  def fork_possible? intersection, mark
    values1 = board.values_at intersection[:first]
    values2 = board.values_at intersection[:second]
    (values1 & values2).include?(mark) && !(values1 | values2).include?(other_mark(mark))
  end

  def center
    center = Board.to_coordinates(5)
    board.available?(center) ? center : nil
  end

  def opposite_corner
    board.corners.shuffle.each do |corner|
      if board.value_at(corner) == opposing_mark
        other_corners = board.corners.reject { |same| same == corner }
        opp_corner = other_corners.find do |opp|
          corner[:row] + corner[:column] + opp[:row] + opp[:column] == 4 # would be nicer with matrices
        end
        return opp_corner if board.value_at(opp_corner).is_a? Integer
      end
    end
    nil
  end

  def empty_side; empty_space(:edges); end
  def empty_corner; empty_space(:corners); end

  def empty_space type
    location = board.send(type).shuffle.find do |cell|
      board.available?(cell)
    end
    location.is_a?(Hash) ? location : nil
  end
end

require_relative './setup'
include Setup

class ComputerPlayer
  attr_reader :mark, :game, :opposing_mark

  STRATEGIES = [
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

  def initialize game, mark
    @mark = mark
    @game = game
    @opposing_mark = (mark == 'X' ? 'O' : 'X')
  end

  def move
    game.mark_board determine_move, mark
  end

  def determine_move
    chosen_move = nil
    STRATEGIES.each do |strategy|
      chosen_move = self.send(strategy)
      break if chosen_move
    end
    chosen_move
  end

  def win
    game.get_rows_columns_and_diagonals.each do |line|
      if line.uniq.count == 2 && !line.include?(opposing_mark)
        number = line.find { |entry| entry.is_a? Integer }
        return Setup.translate(number)
      end
    end
    nil
  end

  def block
    game.get_rows_columns_and_diagonals.each do |line|
      if line.uniq.count == 2 && !line.include?(mark)
        number = line.find { |entry| entry.is_a? Integer }
        return Setup.translate(number)
      end
    end
    nil
  end

  def make_fork
    game.intersecting_lines.each do |intersection_info|
      first = intersection_info[:first]
      second = intersection_info[:second]
      intersection = intersection_info[:space]

      if first.include?(mark) && !first.include?(opposing_mark) && second.include?(mark) && !second.include?(opposing_mark)
        if game.available_spaces.include?(intersection)
          return Setup.translate(intersection)
        end
      end
    end
    nil
  end

  def forks
    all_forks = []
    game.intersecting_lines.each do |intersection_info|
      first = intersection_info[:first]
      second = intersection_info[:second]
      intersection = intersection_info[:space]

      if first.include?(mark) && !first.include?(opposing_mark) && second.include?(mark) && !second.include?(opposing_mark)
        if game.available_spaces.include?(intersection)
          all_forks << Setup.translate(intersection)
        end
      end
    end
    all_forks
  end

  def block_fork_indirectly
    game.get_rows_columns_and_diagonals.each do |line|
      if line.include?(mark) && !line.include?(opposing_mark)
        possible_choices = line & game.available_spaces
        possible_choices.each do |space_number|
          temp_game = Game.new
          fake_opponent = ComputerPlayer.new(temp_game, opposing_mark)

          new_board_matrix = Marshal.load(Marshal.dump(game.board_matrix))

          temp_game.board_matrix = new_board_matrix
          temp_game.mark_board Setup.translate(space_number), mark

          unless fake_opponent.forks.any? { |fork| fork == fake_opponent.block }
            return Setup.translate(space_number)
          end
        end
      end
    end
    nil
  end

  def block_fork_directly
    game.intersecting_lines.each do |intersection_info|
      first = intersection_info[:first]
      second = intersection_info[:second]
      intersection = intersection_info[:space]

      if first.include?(opposing_mark) && !first.include?(mark) && second.include?(opposing_mark) && !second.include?(mark)
        if game.available_spaces.include?(intersection)
          return Setup.translate(intersection)
        end
      end
    end
    nil
  end

  def center
    game.available_spaces.include?(5) ? Setup.translate(5) : nil
  end

  def empty_corner
    game.corners.each do |corner_space|
      if game.available_spaces.include?(corner_space)
        return Setup.translate(corner_space)
      end
    end
    nil
  end

  def opposite_corner
    if game.board_matrix[0][0] == opposing_mark && game.available_spaces.include?(9)
      return Setup.translate(9)
    elsif game.board_matrix[0][2] == opposing_mark && game.available_spaces.include?(7)
      return Setup.translate(7)
    elsif game.board_matrix[2][0] == opposing_mark && game.available_spaces.include?(3)
      return Setup.translate(3)
    elsif game.board_matrix[2][2] == opposing_mark && game.available_spaces.include?(1)
      return Setup.translate(1)
    end
    nil
  end

  def empty_side
    game.edges.each do |side_space|
      if game.available_spaces.include?(side_space)
        return Setup.translate(side_space)
      end
    end
    nil
  end
end

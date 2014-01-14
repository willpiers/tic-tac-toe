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
    @opposing_mark = other_mark(mark)
  end

  def move
    game.mark_board determine_move, mark
  end

  def determine_move
    STRATEGIES.each do |strategy|
      chosen_move = self.send(strategy)
      return chosen_move if chosen_move
    end
  end

  def other_mark mark
    mark == 'X' ? 'O' : 'X'
  end

  def win; complete_line(mark); end
  def block; complete_line(opposing_mark); end

  def complete_line opposing_mark
    close_line = game.all_lines.find { |line| line.uniq.count == 2 && !line.include?(other_mark(opposing_mark)) } || []
    move = close_line.find { |entry| entry.is_a? Integer }
    Setup.translate(move)
  end

  def make_fork; forks.sample; end

  def forks
    all_forks = []
    game.intersecting_lines.each do |intersection|
      cell = intersection[:space]
      if fork_possible(intersection, mark)
        if game.available_spaces.include?(cell)
          all_forks << Setup.translate(cell)
        end
      end
    end
    all_forks
  end

  def block_fork_indirectly
    game.all_lines.each do |line|
      if line.include?(mark) && !line.include?(opposing_mark)
        possible_choices = line & game.available_spaces
        possible_choices.each do |space_number|
          fake_game = Game.new
          fake_opponent = ComputerPlayer.new(fake_game, opposing_mark)

          fake_game.board_matrix = Marshal.load( Marshal.dump( game.board_matrix ) )
          fake_game.mark_board Setup.translate(space_number), mark

          unless fake_opponent.forks.any? { |fork| fork == fake_opponent.block }
            return Setup.translate(space_number)
          end
        end
      end
    end
    nil
  end

  def block_fork_directly
    game.intersecting_lines.each do |intersection|
      if fork_possible(intersection, opposing_mark)
        if game.available_spaces.include?(intersection[:space])
          return Setup.translate(intersection[:space])
        end
      end
    end
    nil
  end

  def fork_possible intersection, mark
    (intersection[:first] & intersection[:second]).include?(mark) &&
      !(intersection[:first] | intersection[:second]).include?(other_mark(mark))
  end

  def center
    game.available_spaces.include?(5) ? Setup.translate(5) : nil
  end

  def opposite_corner
    if game.corners[0] == opposing_mark && game.available_spaces.include?(9)
      Setup.translate(9)
    elsif game.corners[1] == opposing_mark && game.available_spaces.include?(7)
      Setup.translate(7)
    elsif game.corners[2] == opposing_mark && game.available_spaces.include?(3)
      Setup.translate(3)
    elsif game.corners[3] == opposing_mark && game.available_spaces.include?(1)
      Setup.translate(1)
    end
  end

  def empty_side; empty_space(:edges); end
  def empty_corner; empty_space(:corners); end

  def empty_space type
    space = game.send(type).shuffle.find { |cell| game.available_spaces.include?(cell) }
    Setup.translate space
  end
end

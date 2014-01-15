class ComputerPlayer
  attr_reader :mark, :game, :opposing_mark

  def initialize game, mark
    @mark = mark
    @game = game
    @opposing_mark = other_mark(mark)
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
    game.mark_board determine_move, mark
  end

  def determine_move
    strategies.each do |strategy|
      chosen_move = self.send(strategy)
      return chosen_move if chosen_move
    end
  end

  def other_mark mark
    mark == 'X' ? 'O' : 'X'
  end

  def win; complete_line(mark); end
  def block; complete_line(opposing_mark); end

  def complete_line the_mark
    close_line = game.board.all_lines.find { |line| two_in_a_row?(line, other_mark(the_mark)) } || []
    move = close_line.find { |entry| entry.is_a? Integer }
    Setup.translate(move)
  end

  def two_in_a_row? line, mark
    line.uniq.count == 2 && !line.include?(mark)
  end

  def make_fork; forks.sample; end

  def forks
    all_forks = []
    game.board.intersecting_lines.each do |intersection|
      cell = intersection[:space]
      if fork_possible(intersection, mark)
        if game.board.available_spaces.include?(cell)
          all_forks << Setup.translate(cell)
        end
      end
    end
    all_forks
  end

  def block_fork_indirectly
    game.board.all_lines.each do |line|
      if line.include?(mark) && !line.include?(opposing_mark)
        possible_choices = line & game.board.available_spaces
        possible_choices.each do |space_number|
          fake_game = Game.new
          fake_opponent = ComputerPlayer.new(fake_game, opposing_mark)

          fake_game.board = Marshal.load( Marshal.dump( game.board ) )
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
    game.board.intersecting_lines.each do |intersection|
      if fork_possible(intersection, opposing_mark)
        if game.board.available_spaces.include?(intersection[:space])
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
    game.board.available_spaces.include?(5) ? Setup.translate(5) : nil
  end

  def opposite_corner
    game.board.corners.shuffle.each do |corner|
      if corner[:val] == opposing_mark
        other_corners = game.board.corners.reject { |same| same == corner }
        opp_corner = other_corners.find do |opp|
          corner[:row] + corner[:col] + opp[:row] + opp[:col] == 4 # would be nicer with matrices
        end
        return Setup.translate(opp_corner[:val]) if opp_corner[:val].is_a? Integer
      end
    end
    nil
  end

  def empty_side; empty_space(:edges); end
  def empty_corner; empty_space(:corners); end

  def empty_space type
    space = game.board.send(type).shuffle.find do |cell|
      game.board.available_spaces.include?(cell[:val])
    end
    Setup.translate space[:val]
  end
end

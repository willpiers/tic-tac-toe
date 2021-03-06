class TttIO
  def self.determine_opponent_type
    puts "would you like to play against a friend, or the computer?"

    answer = nil
    until ['1','2'].include? answer
      puts "press 1 for computer, and 2 for human."
      answer = accept_input
    end
    answer == '1' ? :computer : :human
  end

  def self.determine_first_player
    puts "who should go first?"

    answer = nil
    until ['1','2'].include? answer
      puts "press 1 for you, and 2 for the other player."
      answer = accept_input
    end
    answer == '1' ? :user : :other
  end

  def self.determine_user_move board, mark
    puts "Pick an open square to move."
    puts "You're #{mark}'s, in case you forgot."

    loop do
      raw_location = accept_input.to_i
      if board.available?(raw_location)
        mark_location = Board.to_coordinates(raw_location)
        return mark_location
      else
        puts "Please choose an available space on the board."
      end
    end
  end

  def self.draw board
    colors = color_board(board)
    clear_screen
    puts "     |     |      "
    puts "  #{ colors[0] }  |  #{ colors[1] }  |  #{ colors[2] }"
    puts "_____|_____|_____"
    puts "     |     |    "
    puts "  #{ colors[3] }  |  #{ colors[4] }  |  #{ colors[5] }"
    puts "_____|_____|_____"
    puts "     |     |    "
    puts "  #{ colors[6] }  |  #{ colors[7] }  |  #{ colors[8] }"
    puts "     |     |    "
  end

  def self.clear_screen; system 'clear'; end

  def self.color_board board
    board.cells.flatten.map do |entry|
      case entry
      when board.x_marker then entry.colorize(:blue)
      when board.o_marker then entry.colorize(:red)
      else entry
      end
    end
  end

  def self.congratulate_winner game
    winner = game.board.x_marker if game.board.check_all_lines(game.board.x_marker)
    winner = game.board.o_marker if game.board.check_all_lines(game.board.o_marker)
    message = winner ? "Good job #{winner}'s" : "Cat's game!"
    puts message
  end

  private

  def self.accept_input
    gets.chomp
  end
end

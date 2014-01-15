module Setup
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

  def self.determine_user_move game, mark
    puts "Pick an open square to move."
    puts "You're #{mark}'s, in case you forgot."

    loop do
      raw_location = accept_input.to_i
      if valid_input?(game, raw_location)
        mark_location = translate(raw_location)
        return mark_location
      else
        puts "Please choose an available space on the board."
      end
    end
  end

  def self.congratulate_winner game
    winner = 'X' if game.board.check_all_lines('X')
    winner = 'O' if game.board.check_all_lines('O')
    if winner
      message = winner ? "Good job #{winner}'s" : "Cat's game!"
      puts message
    else
      puts "Cat's game!"
    end
  end

  def translate mark_location
    return nil unless mark_location
    row = (mark_location.to_f/3.0).ceil - 1
    column = (mark_location - 1) % 3
    {row: row, column: column}
  end

  def valid_input? game, location
    return false unless location.is_a?(Integer)
    return false unless location > 0 || location < 10
    return false unless game.board.available_spaces.include?(location)
    true
  end

  private

  def self.accept_input
    gets.chomp
  end
end

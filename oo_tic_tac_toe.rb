class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  attr_reader :squares

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def at_risk_square(marker)
    square = nil
    WINNING_LINES.each do |line|
      if (line.count {|key| @squares[key] == marker} == 2) &&
          (line.count {|key| @squares[key] == Square::INITIAL_MARKER}) == 1
        square = line.select {|key| @squares[key] == Square::INITIAL_MARKER}.first
      end
    end
    square
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_accessor :marker, :name, :score

  def initialize(marker = nil, name = nil)
    @marker = marker
    @name = name
    @score = 0
  end
end

class TTTGame
  COMPUTER_MARKER = "O"
  ROUNDS_TO_WIN = 5

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = nil
  end

  def play
    clear
    display_welcome_message
    set_human_name
    set_computer_name
    set_human_marker
    first_to_move
    main_game
    display_goodbye_message
  end

  private

  def set_human_name
    puts "Please enter your name:"
    answer = gets.chomp.downcase
    human.name = answer
    puts ""
  end

  def set_human_marker
    puts "Please choose your marker (select any character other than 'O'):"
    answer = nil
    loop do
      answer = gets.chomp.to_s
      break if answer != COMPUTER_MARKER
      puts "Sorry, that's the #{computer.name}'s' marker. Please choose again."
    end
    human.marker = answer
    puts ""
  end

  def set_computer_name
    computer.name = ["robot1", "robot2", "robot3"].sample
  end

  def first_to_move
    @current_marker = human.marker
  end

  def main_game
    loop do
      loop do
        display_board
        display_score
        player_move
        update_score
        display_round_result
        break unless start_next_round?
        break if game_over?
        reset
      end
      display_winner
      puts ""
      break unless play_again?
      display_play_again_message
    end
  end

  def player_move
    loop do
      current_player_moves
      #binding.pry      
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe! First player to 5 wins."
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def start_next_round?
    answer = nil
    loop do
      puts "Ready for the next round? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def human_turn?
    @current_marker == human.marker
  end

  def update_score
    case board.winning_marker
    when human.marker
      human.score += 1
    when computer.marker
      computer.score += 1
    end
  end

  def display_score
    puts "--- CURRENT SCORE ---"
    puts "#{human.name}: #{human.score} | #{computer.name}: #{computer.score}"
    puts ""
  end

  def game_over?
    human.score == ROUNDS_TO_WIN || computer.score == ROUNDS_TO_WIN
  end

  def display_winner
    if human.score == ROUNDS_TO_WIN
      puts "#{human.name} won the game!"
    elsif computer.score == ROUNDS_TO_WIN
      puts "#{computer.name} won the game!"
    end
  end

  def display_board
    puts "Hey #{human.name}, your marker is a #{human.marker}."
    puts ""
    puts "The computer, #{computer.name} is your opponent."
    puts ""
    puts "#{computer.name}'s marker is an #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def joinor(arr, delimiter=', ', word='or')
    case arr.size
    when 0 then ''
    when 1 then arr.first.to_s
    when 2 then arr.join(" #{word} ")
    else
      arr[-1] = "#{word} #{arr.last}"
      arr.join(delimiter)
    end
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    square = nil

    Board::WINNING_LINES.each do |line|
      if (line.count {|key| board.squares[key].marker == computer.marker} == 2) &&
          (line.count {|key| board.squares[key].marker == Square::INITIAL_MARKER}) == 1
        square = line.select {|key| board.squares[key].marker == Square::INITIAL_MARKER}.first
        return board[square] = computer.marker
      end
    end

    Board::WINNING_LINES.each do |line|
      if (line.count {|key| board.squares[key].marker == human.marker} == 2) &&
          (line.count {|key| board.squares[key].marker == Square::INITIAL_MARKER}) == 1
        square = line.select {|key| board.squares[key].marker == Square::INITIAL_MARKER}.first
        return board[square] = computer.marker
      end
    end

    if !square
      square = board.unmarked_keys.sample
    end

    board[square] = computer.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def display_round_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "You won the round!"
    when computer.marker
      puts "#{computer.name} won the round!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def clear
    system "clear"
  end

  def reset
    board.reset
    @current_marker = first_to_move
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

game = TTTGame.new
game.play

require 'abbrev'

RULES = <<-HEREDOC
Welcome to Tic-Tac-Toe! Get three of your symbols in a row!

The winner of a coin flip will pick their symbol and will go first.

Play as many games as you wish - the number of wins for each player
and the number of ties will be recorded.

After each game, the player order will alternate.
HEREDOC

WIN_SEQUENCES = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
  [1, 4, 7],
  [2, 5, 8],
  [3, 6, 9],
  [1, 5, 9],
  [3, 5, 7]
]

possible_moves = {
  # square number => [square name, string index, symbol in square]
  1 => ['top left', 2, ' '],
  2 => ['top center', 6, ' '],
  3 => ['top right', 10, ' '],
  4 => ['center left', 28, ' '],
  5 => ['center', 32, ' '],
  6 => ['center right', 36, ' '],
  7 => ['bottom left', 54, ' '],
  8 => ['bottom center', 58, ' '],
  9 => ['bottom right', 62, ' ']
}

wins_totals = { you: 0, computer: 0, ties: 0 }

# rubocop:disable Layout/LineLength
def display_wins_totals(wins_totals)
  user = wins_totals[:you]
  u_game = equality_ternary(user, 1, 'game', 'games')

  computer = wins_totals[:computer]
  c_game = equality_ternary(computer, 1, 'game', 'games')

  ties = wins_totals[:ties]
  t_verb = equality_ternary(ties, 1, 'was', 'were')
  t_game = equality_ternary(ties, 1, 'tie', 'ties')

  prompt "You won #{user} #{u_game}, the computer won #{computer} #{c_game}, and there #{t_verb} #{ties} #{t_game}."
end
# rubocop:enable Layout/LineLength

def prompt(message)
  puts "=> #{message}"
end

def equality_ternary(first_object, second_object, if_true, if_false)
  first_object == second_object ? if_true : if_false
end

def clear_gameboard(possible_moves)
  possible_moves.each do |_, status|
    status[2] = ' '
  end
end

# rubocop:disable Layout/TrailingWhitespace
def gameboard
  <<-HEREDOC
	   |   |   
	---+---+---
	   |   |   
	---+---+---
	   |   |   
  HEREDOC
end
# rubocop:enable Layout/TrailingWhitespace

def update_gameboard(possible_moves)
  board = gameboard
  possible_moves.each do |_, square|
    board[square[1]] = square[2]
  end
  board
end

def display_gameboard(possible_moves)
  puts update_gameboard(possible_moves)
end

def display_open_squares(possible_moves)
  possible_moves.each do |square_id, status|
    prompt "Type the number #{square_id} for #{status[0]}" if status[2] == ' '
  end
end

def validate_coin_flip_user_input(heads, tails)
  choice = ''
  loop do
    user_input = gets.chomp
    if heads.keys.include?(user_input)
      choice = 'heads'
      break
    elsif tails.keys.include?(user_input)
      choice = 'tails'
      break
    else
      prompt "Invalid choice. Pick 'heads' or 'tails':"
    end
  end
  choice
end

def validate_user_selection(possible_moves, move_id)
  possible_moves.select do |square_id, status|
    square_id == move_id && status[2] == ' '
  end
end

def validate_play_again(answer)
  if answer.start_with?('y')
    true
  elsif answer.start_with?('n')
    false
  else
    prompt "Invalid response. Choose 'yes' or 'no':"
  end
end

def select_coin_flip_choice
  heads = ['heads'].abbrev
  tails = ['tails'].abbrev
  prompt "Pick 'heads' or 'tails':"
  validate_coin_flip_user_input(heads, tails)
end

def coin_flip
  choice = select_coin_flip_choice
  number = rand(1..2)
  number.odd? ? (coin = "heads") : (coin = "tails")

  first = equality_ternary(choice, coin, :user, :computer)
  first_player = equality_ternary(first, :user, 'You', 'The computer')
  prompt "It's #{coin}! You chose #{choice}. #{first_player} will play first."
  first
end

def select_symbol(first_player)
  case first_player
  when :user
    select_user_symbol
  when :computer
    select_computer_symbol
  end
end

def select_user_symbol
  symbol = ''
  prompt "Do you want to be 'X's or 'O's?"
  loop do
    symbol = gets.chomp.upcase
    break if symbol.start_with?('X') || symbol.start_with?('O')
    prompt "Invalid choice. Pick 'X' or 'O':"
  end
  symbol[0]
end

def select_computer_symbol
  random = rand(1..2)
  symbol = random.even? ? 'X' : 'O'
  prompt "The computer chooses '#{symbol}'s."
  symbol
end

def update_possible_moves(square, symbol, possible_moves)
  possible_moves[square][2] = symbol
end

def select_user_move(symbol, possible_moves)
  prompt "Choose from the following moves:"
  loop do
    display_open_squares(possible_moves)
    move_id = gets.chomp.to_i
    move = validate_user_selection(possible_moves, move_id)
    if move.empty?
      prompt "What?! Pick a number that corresponds with an open square:"
    else
      update_possible_moves(move_id, symbol, possible_moves)
      break
    end
  end
end

def select_random_computer_move(symbol, possible_moves)
  open_squares = possible_moves.select do |_, status|
    status[2] == ' '
  end
  prompt "The computer chooses..."
  possible_moves[open_squares.keys.sample][2] = symbol
  display_gameboard(possible_moves)
end

def select_defensive_computer_move(symbol, possible_moves)
  threats = check_for_threat(symbol, possible_moves)
  threats[0]
end

def select_offensive_computer_move(symbol, possible_moves)
  opportunities = check_for_opportunity(symbol, possible_moves)
  opportunities[0]
end

def open_squares(possible_moves)
  possible_moves.select do |_, status|
    status[2] == ' '
  end
end

def enemy_squares(possible_moves, enemy_symbol)
  possible_moves.select do |_, status|
    status[2] == enemy_symbol
  end
end

def friendly_squares(possible_moves, symbol)
  possible_moves.select do |_, status|
    status[2] == symbol
  end
end

def check_for_threat(symbol, possible_moves)
  enemy_symbol = equality_ternary(symbol, 'X', 'O', 'X')
  open_squares = open_squares(possible_moves).keys
  enemy_squares = enemy_squares(possible_moves, enemy_symbol).keys

  threats = WIN_SEQUENCES.map do |sequence|
    (sequence - enemy_squares)
  end

  threats.delete_if { |threat| threat.size > 1 }
  threats.flatten!
  threats.select { |threat| open_squares.include?(threat) }
end

def check_for_opportunity(symbol, possible_moves)
  open_squares = open_squares(possible_moves).keys
  friendly_squares = friendly_squares(possible_moves, symbol).keys

  opportunities = WIN_SEQUENCES.map do |sequence|
    (sequence - friendly_squares)
  end

  opportunities.delete_if { |opportunity| opportunity.size > 1 }
  opportunities.flatten!
  opportunities.select { |opportunity| open_squares.include?(opportunity) }
end

def select_occupied_squares(symbol, possible_moves)
  squares = possible_moves.select { |_, status| status[2] == symbol }
  squares.keys
end

def select_winning_sequence(occupied_squares)
  WIN_SEQUENCES.select do |sequence|
    sequence.all? { |seq| occupied_squares.include?(seq) }
  end
end

def check_for_winner(symbol, possible_moves)
  occupied_squares = select_occupied_squares(symbol, possible_moves)
  select_winning_sequence(occupied_squares).flatten.shift(3)
end

def winner?(symbol, possible_moves)
  winning_sequence = check_for_winner(symbol, possible_moves)
  if winning_sequence.any?
    return true, winning_sequence
  end
end

def display_winning_gameboard(possible_moves, winning_sequence)
  winning_sequence.each do |square_id|
    possible_moves[square_id][2] = 'W'
  end
  display_gameboard(possible_moves)
end

def check_for_tie(possible_moves)
  possible_moves.all? do |_, status|
    status[2] != ' '
  end
end

def tie?(possible_moves)
  if check_for_tie(possible_moves)
    prompt "Blah! It's a tie..."
    true
  end
end

def play_again?
  prompt "Do you want to play again?"
  again = ''
  loop do
    play_again = gets.chomp.downcase
    again = validate_play_again(play_again)
    break if again.instance_of?(TrueClass) || again.instance_of?(FalseClass)
  end
  again
end

def user_move(symbol, possible_moves)
  prompt "It's your move! Here's what the board looks like:"
  display_gameboard(possible_moves)
  select_user_move(symbol, possible_moves)
end

def computer_move(symbol, possible_moves)
  prompt "It's the computer's move! Here's what the board looks like:"
  display_gameboard(possible_moves)
  defensive_move = select_defensive_computer_move(symbol, possible_moves)
  offensive_move = select_offensive_computer_move(symbol, possible_moves)
  if !offensive_move.nil?
    possible_moves[offensive_move][2] = symbol
  elsif !defensive_move.nil?
    possible_moves[defensive_move][2] = symbol
  else
    select_random_computer_move(symbol, possible_moves)
  end
end

# rubocop:disable Metrics/MethodLength
def user_moves_first(first_player_symbol,
                     second_player_symbol,
                     possible_moves)
  loop do
    user_move(first_player_symbol, possible_moves)
    winner, winning_sequence = winner?(first_player_symbol, possible_moves)
    if winner
      prompt "Nice! You win!"
      display_winning_gameboard(possible_moves, winning_sequence)
      return :you
    end
    if tie?(possible_moves)
      display_gameboard(possible_moves)
      return :ties
    end
    computer_move(second_player_symbol, possible_moves)
    winner, winning_sequence = winner?(second_player_symbol, possible_moves)
    if winner
      prompt "Uh oh! The computer wins!"
      display_winning_gameboard(possible_moves, winning_sequence)
      return :computer
    end
  end
end

def computer_moves_first(first_player_symbol,
                         second_player_symbol,
                         possible_moves)
  loop do
    computer_move(first_player_symbol, possible_moves)
    winner, winning_sequence = winner?(first_player_symbol, possible_moves)
    if winner
      prompt "Uh oh! The computer wins!"
      display_winning_gameboard(possible_moves, winning_sequence)
      return :computer
    end
    if tie?(possible_moves)
      display_gameboard(possible_moves)
      return :ties
    end
    user_move(second_player_symbol, possible_moves)
    winner, winning_sequence = winner?(second_player_symbol, possible_moves)
    if winner
      prompt "Nice! You win!"
      display_winning_gameboard(possible_moves, winning_sequence)
      return :you
    end
  end
end
# rubocop:enable Metrics/MethodLength

puts RULES
first_player = coin_flip

# rubocop:disable Layout/LineLength
loop do
  first_player_symbol = select_symbol(first_player)
  second_player_symbol = equality_ternary(first_player_symbol, 'X', 'O', 'X')

  if first_player == :user
    result = user_moves_first(first_player_symbol, second_player_symbol, possible_moves)
    wins_totals[result] += 1
    first_player = equality_ternary(first_player, :user, :computer, :user)
    if play_again?
      prompt "You went first last time, the computer will play first this round."
    else
      prompt "Thanks for playing!"
      break
    end
  else
    result = computer_moves_first(first_player_symbol, second_player_symbol, possible_moves)
    wins_totals[result] += 1
    first_player = equality_ternary(first_player, :user, :computer, :user)
    if play_again?
      prompt "The computer went first last time, you will play first this round."
    else
      prompt "Thanks for playing!"
      break
    end
  end

  clear_gameboard(possible_moves)
end
# rubocop:enable Layout/LineLength

display_wins_totals(wins_totals)

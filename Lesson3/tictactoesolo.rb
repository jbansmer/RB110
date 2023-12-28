=begin

-- Show initial (empty) gameboard
1. Determine whether user or computer goes first (coin flip sim)
2. First play
	- use `abbrev` on a list of possible moves (center, top right, bottom left, center right, etc)
-- Show updated game board
3. Check for three in a row. If yes, last player to move wins. If no, keep playing
... repeat this up to 9 times ...
4. After 9 moves, if no one wins, the game is a tie.
5. Play again? If yes, start from 2 with the opposite player starting. If no, end game
-- Display winner message, tie message, goodbye message, greeting message, etc as needed

=end

=begin

Helper Method algorithms:
Displaying and updating gameboard:
	- gameboard: return an empty grid that is 13 characters by 13 lines. Rows/lines 5 and 9 should be a | and _, respectively
	- update_gameboard(most current move): modify the gameboard so that `gameboard` returns with previous moves shown
	- display_gameboard: print the updated gameboard to the console
Getting user and computer move:
	- in an array (possible_moves): list all open squares
	- use `abbrev` on a list of possible moves (center, top right, bottom left, center right, etc)
	- solicit a response with all possible squares an option
	- once a square has been played, remove it from the array
	- computer will choose a square randomly by index from all open squares
Coin-Flip start:
	- coin_flip(previous winner=0): assign user to odd numbers and and computer to even, generate 1 or 2 randomly. Winner chooses first.
		- default parameter value used to handle first game; after that if user wins the argument is 1, computer is 2.
		- use the parameter to generate a case statement to handle different first player conditions
Handling the move data:
 - in a hash(moves_hash): assign values for user or computer to various keys for different squares
 - in a seperate hash (wins_hash): for keys of all squares, values or all possible winning square combinations
Check for winner: 
	- compare_hashes: generate an array of all squares for user, a similar array for computer; compare with values in wins_hash

=end

require 'abbrev'

moves_hash = {
	top_left: [2, 'X', 1],
	top_center: [6, 'X', 2],
	top_right: [10, ' ', 3],
	center_left: [28, 'O', 4],
	center: [32, 'O', 5],
	center_right: [36, ' ', 6],
	bottom_left: [54, 'O', 7],
	bottom_center: [58, 'X', 8],
	bottom_right: [62, ' ', 9]
}

win_sequences = [
	top_across = [1, 2, 3],
	mid_across = [4, 5, 6],
	bottom_across = [7, 8, 9],
	left_down = [1, 4, 7],
	mid_down = [2, 5, 8],
	right_down = [3, 6, 9],
	diag_right= [1, 5, 9],
	diag_left = [3, 5, 7],
]

wins_hash = {
	top_left: [top_across, left_down, diag_right],
	top_center: [top_across, mid_down],
	top_right: [top_across, right_down, diag_left],
	center_left: [mid_across, left_down],
	center: [mid_across, mid_down, diag_right, diag_left],
	center_right: [mid_across, right_down],
	bottom_left: [bottom_across, left_down, diag_left],
	bottom_center: [bottom_across, mid_down],
	bottom_right: [bottom_across, right_down, diag_right]
}

def update_occupied_squares(moves_hash, symbol)
	symboled_squares = moves_hash.select { |_, status| status[1] == symbol }
	symboled_squares = symboled_squares.values
	square_ids = []
	symboled_squares.each do |status_array|
		square_ids << status_array[2]
	end
	square_ids
end

def get_winning_squares_sequence(wins_hash, square_ids)
	win_id = []
	wins_hash.each do |square, all_wins|
		win_id << all_wins.select do |win|
			win.all? { |loc| square_ids.include?(loc) }
		end
	end
	win_id.flatten.shift(3)
end

def check_for_winner(wins_hash, moves_hash, symbol)
	square_ids = update_occupied_squares(moves_hash, symbol)
	get_winning_squares_sequence(wins_hash, square_ids)
end

def get_winning_squares_location(wins_hash, winning_sequence)
	winning_squares = []
	wins_hash.each do |square, all_seqs|
		if all_seqs.include?(winning_sequence)
			winning_squares << square
		end
	end
	winning_squares
end

def display_winning_gameboard(moves_hash, winning_squares)
	board = gameboard
	moves_hash.each do |square, status|
		if winning_squares.include?(square)
			status[1] = 'W'
		end
	end
	update_gameboard(moves_hash)
end

def prompt(message)
	puts "=> #{message}"
end

def get_coin_flip_choice
	prompt "Pick 'heads' or 'tails':"
	choice = gets.chomp
	loop do
		heads = ['heads'].abbrev
		tails = ['tails'].abbrev
		if heads.keys.include?(choice)
			choice = 'heads'
			break
		elsif tails.keys.include?(choice)
			choice = 'tails'
			break
		else
			prompt "Invalid choice. Pick 'heads' or 'tails':"
			choice = gets.chomp
		end
	end
	choice
end

def coin_flip(choice)
	num = rand(1..2)
	num.odd? ? (coin = "heads") : (coin = "tails")
	choice == coin ? (first = 'You') : (first = 'The computer')
	prompt "It's #{coin}! You chose #{choice}. #{first} will play first."
	first
end

def gameboard
	<<-HEREDOC
	   |   |   
	---|---|---
	   |   |   
	---|---|---
	   |   |   
	HEREDOC
end

def update_gameboard(moves_hash)
	board = gameboard
	moves_hash.each do |_, square|
		board[square[0]] = square[1]
	end
	puts board
end

def display_gameboard(moves_hash)
	puts update_gameboard(moves_hash)
end

def get_user_symbol
	symbol = ''
	prompt "Do you want to be 'X's or 'O's?"
	loop do
		symbol = gets.chomp.upcase
		break if symbol.start_with?('X') || symbol.start_with?('O')
		prompt "Invalid choice. Pick 'X' or 'O'."
	end
	symbol[0]
end

def get_computer_symbol
	random = rand(1..2)
	random.even? ? symbol = 'X' : symbol = 'O'
	symbol
end

def get_user_move(symbol, moves_hash)
	prompt "Choose from the following moves:"
	move = ''
	loop do
		moves_hash.each do |square, status|
			square_string = square.to_s.gsub('_', ' ')
			prompt "Type the number (#{status[2]}) for #{square_string}" if status[1] == ' '
		end
		move_id = gets.chomp.to_i
		move = moves_hash.select do |_, status|
			status[1] == ' ' && status[2] == move_id
		end
		move = move.to_a
		if move.empty?
			display_gameboard(moves_hash)
			prompt "Invalid entry. Choose again..."
		else
			break
		end
	end
	move_location = move[0][1][2]
	moves_hash[move[0][0]][1] = symbol
end

def get_random_computer_move(symbol, moves_hash)
	possible_moves = moves_hash.select { |_, status| status[1] == ' ' }
	open_squares = possible_moves.keys
	random = rand(0..(open_squares.size - 1))
	move = open_squares[random]
	moves_hash[move][1] = symbol
end

def check_for_threat(moves_hash, win_sequences, possible_moves, symbol)
	symbol == 'X' ? enemy_symbol = 'O' : enemy_symbol = 'X'
	open_squares = []
	possible_moves.each do |_, status|
		open_squares << status[2]
	end
	enemy_squares = []
	moves_hash.each do |_, status|
		enemy_squares << status[2] if status[1] == enemy_symbol
	end
	threats = win_sequences.map do |sequence|
		(sequence - enemy_squares)
	end
	threats.delete_if { |threats| threats.size > 1 }
	threats.flatten!
	threat = threats.select { |threat| open_squares.include?(threat) }
	threat[0]
end

def get_defensive_computer_move(symbol, moves_hash, wins_hash, win_sequences)
	possible_moves = moves_hash.select { |_, status| status[1] == ' ' }
	threat_location = check_for_threat(moves_hash, win_sequences, possible_moves, symbol)
	moves_hash.each do |_, status|
		if status[2] == threat_location
			status[1] = symbol
		end
	end
end

def execute_gameplay_user_first(moves_hash, wins_hash)
		user_symbol = get_user_symbol
		user_symbol == 'X' ? computer_symbol = 'O' : computer_symbol = 'X'
		winning_symbol = ''
		loop do
			prompt "Here's what the gameboard looks like:"
			display_gameboard(moves_hash)
			get_user_move(user_symbol, moves_hash)
			display_gameboard(moves_hash)
			winning_symbol = user_symbol
			if check_for_winner(wins_hash, moves_hash, user_symbol).any?
				prompt "Look at that, you won!"
				break
			end

			prompt "The computer chooses..."
			get_random_computer_move(computer_symbol, moves_hash)
			display_gameboard(moves_hash)
			winning_symbol = computer_symbol
			if check_for_winner(wins_hash, moves_hash, computer_symbol).any?
				prompt "Uh oh! The computer beat you!"
				break
			end
		end

		winning_sequence = check_for_winner(wins_hash, moves_hash, winning_symbol)
		winning_squares = get_winning_squares_location(wins_hash, winning_sequence)
		display_winning_gameboard(moves_hash, winning_squares)
end

def execute_gameplay_computer_first(moves_hash, wins_hash)
	computer_symbol = get_computer_symbol
	computer_symbol == 'X' ? user_symbol = 'O' : user_symbol = 'X'
	prompt "the computer chooses '#{computer_symbol}'. You will play as '#{user_symbol}'."
	winning_symbol = ''
	loop do
		prompt "The computer chooses..."
		get_random_computer_move(computer_symbol, moves_hash)
		display_gameboard(moves_hash)
		winning_symbol = computer_symbol
		if check_for_winner(wins_hash, moves_hash, computer_symbol).any?
			prompt "Uh oh! The computer beat you!"
			break
		end

		prompt "Here's what the gameboard looks like:"
		display_gameboard(moves_hash)
		get_user_move(user_symbol, moves_hash)
		display_gameboard(moves_hash)
		winning_symbol = user_symbol
		if check_for_winner(wins_hash, moves_hash, user_symbol).any?
			prompt "Look at that, you won!"
			break
		end
	end

	winning_sequence = check_for_winner(wins_hash, moves_hash, winning_symbol)
	winning_squares = get_winning_squares_location(wins_hash, winning_sequence)
	display_winning_gameboard(moves_hash, winning_squares)
end

def get_order_of_play(moves_hash, wins_hash)
	choice = get_coin_flip_choice
	first = coin_flip(choice)
	if first == 'The computer'
		execute_gameplay_computer_first(moves_hash, wins_hash)
	else
		execute_gameplay_user_first(moves_hash, wins_hash)
	end
end

# p winning_sequence = check_for_winner(wins_hash, moves_hash, 'X')
# p winning_squares = get_winning_squares_location(wins_hash, winning_sequence)
# puts display_winning_gameboard(moves_hash, winning_squares)

# puts get_order_of_play(moves_hash, wins_hash)
# possible_moves = get_defensive_computer_move('X', moves_hash, wins_hash)
display_gameboard(moves_hash)
get_defensive_computer_move('X', moves_hash, wins_hash, win_sequences)
display_gameboard(moves_hash)

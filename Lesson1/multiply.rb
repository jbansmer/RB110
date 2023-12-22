def multiply(numbers, multiplier)
	multiplied_numbers = []
	counter = 0

	loop do
		break if counter >= numbers.length

		multiplied_numbers << (numbers[counter] * multiplier)

		counter += 1
	end
	multiplied_numbers
end

my_numbers = [1, 4, 3, 7, 2, 6]
p multiply(my_numbers, 3) # => [3, 12, 9, 21, 6, 18]
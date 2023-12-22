def double_odd_indexes(numbers)
	counter = 0
	odd_indexed = []

	loop do
		break if counter >= numbers.length

		if counter.odd?
			odd_indexed << (numbers[counter] * 2)
		else
			odd_indexed << numbers[counter]
		end

		counter += 1
	end
	odd_indexed
end

given_numbers = [1, 4, 3, 7, 2, 6]
p double_odd_indexes(given_numbers)
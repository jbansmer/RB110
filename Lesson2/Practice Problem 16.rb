# Each UUID consists of 32 hexadecimal characters, and is typically broken into 5 sections like this 8-4-4-4-12 and represented as a string.
# It looks like this: "f65c57f6-a6aa-17a8-faa1-a67f2dc9fa91"
# Write a method that returns one UUID when called with no parameters.

def uuid
	id_array = [[], [], [], [], []]
	id_numbers = %w(1 2 3 4 5 6 7 8 9 0 a b c d e f)
	id_format = [8, 4, 4, 4, 12]

	idx = 0
	
	loop do
		id_format[idx].times do |i|
			id_array[idx] << id_numbers[(rand(0..15))]
		end

		if idx < 4
			id_array[idx] << '-'
		end

		idx += 1
		break if idx >= 5
	end
	id_array.join
end

p uuid
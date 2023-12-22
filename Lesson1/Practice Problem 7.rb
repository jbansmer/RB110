# create a hash that has each letter from the string as a key and the frequency with which the letters appear as the values:

statement = "The Flintstones Rock"

frequency = {}

letters = statement.chars
letters.delete(' ')

letters.each do |char|

	if frequency.key?(char)
		frequency[char] += 1
	else
		frequency[char] = 1
	end

end

p frequency
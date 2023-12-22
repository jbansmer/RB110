def joinor(array, seperator=', ', caboose='or')
	joined_string = array.join(seperator)
	joined_string[-3] = " #{caboose}"
	joined_string
end

p joinor([1, 2])                   # => "1 or 2"
p joinor([1, 2, 3])                # => "1, 2, or 3"
p joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
p joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"
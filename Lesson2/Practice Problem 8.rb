# output all vowels of strings using Hash#each:

hsh = {first: ['the', 'quick'], second: ['brown', 'fox'], third: ['jumped'], fourth: ['over', 'the', 'lazy', 'dog']}

hsh.each do |_, strings|
	strings.each do |word|
		word.chars.each do |letter|
			puts letter if "aeiouAEIOU".include?(letter)
		end
	end
end
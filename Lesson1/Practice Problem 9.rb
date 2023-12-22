# write the `titleize` method from rails to capitalize each word in a string:

words = "the flintstones rock"

def titleize(message)
	words = message.split(' ')
	title = []
	words.each do |word|
		title << word.capitalize
	end
	title.join(' ')
end

p titleize(words)
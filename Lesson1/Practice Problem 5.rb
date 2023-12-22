# find the index of the first name that starts with 'Be':

flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

flintstones.each_with_index do |name, index|
	if name.start_with?('Be')
		p index
	end
end
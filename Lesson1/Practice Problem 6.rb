# modify the array to shorten the names to the first three characters:

flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

flintstones.map! do |name|
	name = name[0..2]
end

p flintstones
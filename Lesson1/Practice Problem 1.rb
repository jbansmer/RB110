# turn the array into a hash where the keys are the position number and values are the names:

flintstones = ["Fred", "Barney", "Wilma", "Betty", "Pebbles", "BamBam"]
flintstones_hash = {}

flintstones.each_with_index do |name, index|
	flintstones_hash[(index + 1).to_s] = name
end

p flintstones_hash
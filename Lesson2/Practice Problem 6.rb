# print the name, age, and gender of the individuals in the hash:
# desired output: (Name) is a (age)-year-old (male or female).

munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

munsters.each do |names, stats|
	name = names
	age = stats['age']
	gender = stats['gender']
	puts "#{name} is a #{age}-year-old #{gender}."
end
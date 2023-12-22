# remove entries where values are ages over 100:

ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }

youngins = {}

ages.select do |name, age|
	if age <= 100
		youngins[name] = age
	end
end

p youngins
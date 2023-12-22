# return an array of the hashes with only even integer values:

arr = [{a: [1, 2, 3]}, {b: [2, 4, 6], c: [3, 6], d: [4]}, {e: [8], f: [6, 10]}]

arr2 = []

arr2 = arr.select do |hash|
	hash.values.all? do |_, vals|
		vals.all? { |val| val.even? }
	end
end

p arr2
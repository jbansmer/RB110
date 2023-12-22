# increment the integers by 1, return a new array, and leave the original array unmodified:
# desired return array: [{a: 2}, {b: 3, c: 4}, {d: 5, e: 6, f: 7}]

arr = [{a: 1}, {b: 2, c: 3}, {d: 4, e: 5, f: 6}]

new_arr = arr.map do |hash|
	new_hash = {}
	hash.each do |key, value|
		new_hash[key] = (value + 1)
	end
	new_hash
end

p arr
p new_arr
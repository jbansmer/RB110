# use Array#select or Array#reject to return a new array of identical structure containing elecments that are multiples of 3:
# desired returned array: [[], [3, 12], [9], [15]]

arr = [[2], [3, 5, 7, 12], [9], [11, 13, 15]]

# using Array#select:

arr2 = arr.map do |sub_arr|
	sub_arr.select { |num| num % 3 == 0 }
end

p arr
p arr2

# using Array#reject:

arr3 = arr.map do |sub_arr|
	sub_arr.reject { |num| num % 3 > 0 }
end

p arr
p arr3
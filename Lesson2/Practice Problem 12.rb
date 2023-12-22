# without using Array#to_h, return a hash where the first element in the sub-array is the key and the second is the value: 

arr = [[:a, 1], ['b', 'two'], ['sea', {c: 3}], [{a: 1, b: 2, c: 3, d: 4}, 'D']]
# expected return value: {:a=>1, "b"=>"two", "sea"=>{:c=>3}, {:a=>1, :b=>2, :c=>3, :d=>4}=>"D"}

hash = {}

arr.each do |sub_arr|
	hash[sub_arr[0]] = sub_arr[1]
end

p hash
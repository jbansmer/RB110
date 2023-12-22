# what is the output:

numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.shift(1)
end

# Line 5 will output the current element to the console (1, 2, 3, and 4, in that order).
# The Array#shift method will remove the first element from `numbers` but won't result in anything outputted.
# The `numbers` array should be empty after all iterations.

p numbers

# Wrong. The output is 1, 3, and [3, 4] on successive lines.
# The array is modified in the middle of iterating, but the Array#each method just moves to the next indexed element.
# Since the first element is removed via Array#shift, the next indexed element (index 1) is actually the integer 3.
# 2 is removed the second time through, and the Array#each method stops iterating because the next elemt (index 2)
# is outside the array.

# what is the output here:

numbers2 = [1, 2, 3, 4]
numbers2.each do |number|
  p number
  numbers2.pop(1)
end

# 1, 2 will be the output. The Array#pop method removes the last element, so after the second iteration the Array#each
# method ends because the next index is outside the array.

p numbers2

# takeaways:

# The iterating method compares its position to the current length of the array, not the original length.
# While they operate on the original array (as opposed to a copy), they operate in real-time and changes made
# during iteration are reflected on the operation.
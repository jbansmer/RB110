# determine values of 'a' and 'b':

a = 2
b = [5, 8]
arr = [a, b]

arr[0] += 2
arr[1][0] -= a

# a => 4
# b => [3, 8]

# a actually equals 2 because it is an immutable object that gets reassigned. While arr is modified, the value referenced by a is not.
# b is modified because it references a collection, which is modified. The objects within the collection, however, are reassigned.
# order the array of hashes by earliest to newest publication date:

books = [
  {title: 'One Hundred Years of Solitude', author: 'Gabriel Garcia Marquez', published: '1967'},
  {title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', published: '1925'},
  {title: 'War and Peace', author: 'Leo Tolstoy', published: '1869'},
  {title: 'Ulysses', author: 'James Joyce', published: '1922'}
]

sorted_books = books.sort do |hash1, hash2|
	hash1[:published] <=> hash2[:published]
end

p sorted_books

# also:

ls_sln = books.sort_by do |hash|
	hash[:published]
end

p ls_sln
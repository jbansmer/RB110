produce = {
  'apple' => 'Fruit',
  'carrot' => 'Vegetable',
  'pear' => 'Fruit',
  'broccoli' => 'Vegetable'
}

# My Solution:
def select_fruit(produce)
	selected_produce = {}
	produce_items = produce.keys
	counter = 0

	loop do
		# I missed this, originally putting it lower:
		break if counter >= produce_items.length

		freggie = produce_items[counter]

		if produce[freggie] == 'Fruit'
			selected_produce[freggie] = 'Fruit'
		end

		counter += 1
	end

	selected_produce
end

p select_fruit(produce) # => {"apple"=>"Fruit", "pear"=>"Fruit"}



# LS Example Solution:
def select_fruit(produce_list)
  produce_keys = produce_list.keys
  counter = 0
  selected_fruits = {}

  loop do
    # this has to be at the top in case produce_list is empty hash
    break if counter == produce_keys.size

    current_key = produce_keys[counter]
    current_value = produce_list[current_key]

    if current_value == 'Fruit'
      selected_fruits[current_key] = current_value
    end

    counter += 1
  end

  selected_fruits
end
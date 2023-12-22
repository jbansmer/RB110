# return an array containing colors of fruits and sizes of vegetables, with sizes all caps and colors capitalized:
# expected return value: [["Red", "Green"], "MEDIUM", ["Red", "Green"], ["Orange"], "LARGE"]

hsh = {
  'grape' => {type: 'fruit', colors: ['red', 'green'], size: 'small'},
  'carrot' => {type: 'vegetable', colors: ['orange'], size: 'medium'},
  'apple' => {type: 'fruit', colors: ['red', 'green'], size: 'medium'},
  'apricot' => {type: 'fruit', colors: ['orange'], size: 'medium'},
  'marrow' => {type: 'vegetable', colors: ['green'], size: 'large'},
}

arr = []

hsh.each_value do |stats|
	if stats[:type] == 'fruit'
		colors = []
		stats[:colors].map do |color|
			colors << color.capitalize
		end
		arr << colors
	elsif stats[:type] == 'vegetable'
		arr << stats[:size].upcase
	end
end

p arr
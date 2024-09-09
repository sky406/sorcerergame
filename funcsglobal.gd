extends Node
# TODO ADD functions that end up being used far too many times 

func sumarray(array):
	var sum = 0 
	for i in array: 
		sum+=i
	return sum

func keyFromArray(key,array):
	#this is just simply a function for my bs way of storing dictionaries in arrays
#basically it gets the dictionarry from an array of dictionaries 
# TODO make this more specific
	for i in array: 
		if i.keys()[0]==key: return i
	print("key not found")

func arraydictcontaining(key,array):
	pass
	# basically an improved versionof the key from array function that just  gives you all dictionaries containing a specific key

extends Node


func _ready():
	
	var x = 1
	
	for i in range (100) :
		x = wrapi(x+1 , 1 ,3)
		print (str(x))
	

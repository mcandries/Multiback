extends Node2D

var test = 1
var tictac = [ 
				[0,0,0],
				[0,0,0],
				[0,0,0]
			 ]

var current_player = 1

func _ready():
	if Gb.network_status != Gb.STATUS_SERVER :
		$ClearAndRestart.visible = false
	pass

func _process(delta):

	# Allow Exit
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().is_network_server():
			Srv.StopServer()
		else:
			Cli.DisconnectFromServer()
		get_tree().change_scene("res://Menu.tscn")

	# Counter
	if Gb.network_status == Gb.STATUS_SERVER :
		rpc("setTest",test+1)
	$Label.text = str(test)
	
	
	# Is it my turn ?
	if current_player == Gb.my_player_number :
		if Input.is_action_just_pressed("mouse_left"):
			for n in $Cases.get_children():
				var rect : CellReferenceRect = n
				var mouse_pos = get_global_mouse_position()
				if rect.get_global_rect().has_point(mouse_pos) :
					var x = rect.cell_coord.x
					var y = rect.cell_coord.y
					if tictac[y][x] == 0 : 
						rpc("setTicTac", x, y, Gb.my_player_number)
						rpc("switchPlayer")
					
	# Show TicTac
	for y in  range(3) :
		for x in range(3):
			var marker : Node2D = get_node("Markers/Mark_"+str(x)+"_"+str(y))
			if tictac[y][x] == 0 :
				marker.visible = false
			if tictac[y][x] == 1 : 
				marker.visible = true
				marker.get_node("Player1").visible = true
				marker.get_node("Player2").visible = false
			if tictac[y][x] == 2 : 
				marker.visible = true
				marker.get_node("Player1").visible = false
				marker.get_node("Player2").visible = true
	
	#Show Turn Info
	if current_player == Gb.my_player_number:
		$TurnInfo.text = "Your turn !"
	else:
		$TurnInfo.text = "Other player is thinking..."
		
remotesync func setTest (value):
	if Srv.SecuryCheckASkedByMaster():
		test = value

remotesync func setTicTac (x,y,player_number):
	#if Srv.SecuryCheckASkedByMaster():
	tictac[y][x] = player_number

remotesync func switchPlayer():
	#if Srv.SecuryCheckASkedByMaster():
	if current_player == 1 :
		current_player = 2
	else : 
		current_player = 1

func _input(event):
	pass		


#func _on_Button_pressed():
#	test += 10000
#	pass # Replace with function body.
#
#
#func _on_Button2_pressed():
#	if Gb.network_status == Gb.STATUS_CLIENT :
#		rpc("setTest", -100)
#	pass # Replace with function body.


func _on_ClearAndRestart_pressed():
	for y in range (3):
		for x in range (3):	
			rpc ("setTicTac", x ,y , 0)

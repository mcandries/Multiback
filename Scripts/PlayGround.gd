extends Node2D

remotesync var test

func _ready():
	#rpc_config("test", MultiplayerAPI.RPC_MODE_REMOTESYNC)
	if Gb.network_status == Gb.STATUS_SERVER :
		test = 1
		print ("reset TEST")
	
func _process(delta):
	$Label.text = str(test)
	
	if Gb.network_status == Gb.STATUS_SERVER :
		rset ("test", test+1)
		
	
	if Input.is_action_just_pressed("mouse_left"):
		for n in $Cases.get_children():
			var rect : CellReferenceRect = n
			var mouse_pos = get_global_mouse_position()
			if rect.get_global_rect().has_point(mouse_pos) :
				var x = rect.cell_coord.x
				var y = rect.cell_coord.y
				var marker : Node2D = get_node("Markers/Mark_"+str(x)+"_"+str(y))
				marker.visible = true

	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().is_network_server():
			Srv.StopServer()
		else:
			Cli.DisconnectFromServer()
		get_tree().change_scene("res://Menu.tscn")


#remotesync func setTest (value):
#	test = value

func _input(event):
#	if Input.is_action_just_pressed("mouse_left"):
#	if event is InputEventMouseButton:
#		if (event ad InputEventMouseButton).
#
#	if event is InputEventMouseMotion:
#		Gb.mouse_pos = event.position
	pass		


func _on_Button_pressed():
	test += 10000
	pass # Replace with function body.

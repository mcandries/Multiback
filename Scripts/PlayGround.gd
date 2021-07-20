extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
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


func _input(event):
#	if Input.is_action_just_pressed("mouse_left"):
#	if event is InputEventMouseButton:
#		if (event ad InputEventMouseButton).
#
#	if event is InputEventMouseMotion:
#		Gb.mouse_pos = event.position
	pass		

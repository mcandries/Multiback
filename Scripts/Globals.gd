extends Node

enum {STATUS_NONE, STATUS_SERVER, STATUS_CLIENT}

var mouse_pos
var dbg_history = "Welcome to Multiback !\n"

var network_status = STATUS_NONE
var my_player_number = 0

func dbg_print(text):
	dbg_history += text + "\n"


func _process(delta):
	var lab : Label = get_tree().get_nodes_in_group("DebugWindow")[0]
	lab.text = dbg_history
	var lines = lab.get_line_count()
	if lab.get_line_count()>12:
		lab.lines_skipped = lab.get_line_count() - 13

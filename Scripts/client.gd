extends Node

var network : NetworkedMultiplayerENet
var ip = "127.0.0.1"
var port = "12121"



func ConnectToServer():
	var err 

	network = NetworkedMultiplayerENet.new()
	Gb.dbg_print("Connection to " + str(ip) + ":" + str(port) + " ...")
	err = network.create_client(ip,port)
	if err != OK :
		Gb.dbg_print("Connection ERROR (CODE : "+str (err)+")")
	else:
		Gb.dbg_print("Trying to connect...")
		get_tree().network_peer = network
		network.connect("connection_failed", self, "_Connection_Failed")
		network.connect("connection_succeeded", self, "_Connection_Succeeded")
		network.connect("server_disconnected", self, "_Server_Disconnected")
		Gb.network_status = Gb.STATUS_CLIENT
		var local_network = network
		yield (get_tree().create_timer(3),"timeout")
		if is_instance_valid(local_network): #In case we shoot the network connection during the 3 seconds
			if local_network == network:
				if network.get_connection_status()==network.CONNECTION_CONNECTING:
					Gb.dbg_print("Connection Timeout")
					DisconnectFromServer()
			else:
				local_network.close_connection(0)



func DisconnectFromServer():
	Gb.dbg_print("Close Network client connection")
	network = null
	get_tree().network_peer = null
	Gb.network_status = Gb.STATUS_NONE

func _Connection_Failed():
	Gb.dbg_print("Connection failed to " + str(ip) + ":" + str(port))
	DisconnectFromServer()

func _Connection_Succeeded():
	Gb.dbg_print("Connected to " + str(ip) + ":" + str(port))
	Gb.my_player_number = 2 # I'am Invited
	get_tree().change_scene("res://PlayGround.tscn")


func _Server_Disconnected():
	Gb.dbg_print("Disconnected from " + str(ip) + ":" + str(port))
	DisconnectFromServer()
	get_tree().change_scene("res://Menu.tscn")
	

extends Node2D

func _ready():
	pass 

func _process(delta):
	
	if Gb.network_status == 0:
		$Srv_UI.visible = true
		$Cli_UI.visible = true
		$Cli_UI/JoinGame_Button.text = "Join Game"
		$Srv_UI/CreateGame_Button.text = "Create Game"
	
	if Gb.network_status == Gb.STATUS_SERVER:
		$Srv_UI.visible = true
		$Cli_UI.visible = false
		$Srv_UI/CreateGame_Button.text = "Close server"
	else : 
		$Srv_UI/HowToJoinMyGame_Label.text = ""
	
	if Gb.network_status == Gb.STATUS_CLIENT:
		$Srv_UI.visible = false
		$Cli_UI.visible = true
		if Cli.network.get_connection_status()!=Cli.network.CONNECTION_DISCONNECTED:
			$Cli_UI/JoinGame_Button.text = "Cancel Connection"		


func _on_CreateGame_Button_pressed():
	if get_tree().is_network_server():
		Srv.StopServer()
	else : 
		Srv.port = int ($Srv_UI/Port_LineEdit.text)
		if Srv.port>1024 and Srv.port<65535:
			Srv.StartServer()
			$Srv_UI/HowToJoinMyGame_Label.text = "Your friend can join the game with IP " + str(Srv.upnpExternalIP) + " and PORT " + str (Srv.port)
		else:
			Gb.dbg_print("ERROR : Port Number must be between 1025 and 65534")


func _on_JoinGame_Button_pressed():
	if Gb.network_status != Gb.STATUS_CLIENT:
		Cli.ip = $Cli_UI/IP_LineEdit.text
		Cli.port = int ($Cli_UI/PortDest_LineEdit.text)
		if Cli.port>1024 and Cli.port<65535:
			Cli.ConnectToServer()
		else :
			Gb.dbg_print("ERROR : Port Number must be between 1025 and 65534")
	else:
		Cli.DisconnectFromServer()

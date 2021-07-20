extends Node

var networkENet : NetworkedMultiplayerENet
var port = 12121
var maxPlayer = 1
var upnp = UPNP.new()
var upnpDiscoverResult
var upnpExternalIP
var upnpDeviceCount
var upnpFirstDevice
var upnpPortResult
var upnpPortDeleteResult

func StartServer():
	var err
	networkENet = NetworkedMultiplayerENet.new()
	err = networkENet.create_server(port,maxPlayer)
	
	if err != OK :
		Gb.dbg_print("Server creation ERROR (CODE : "+str (err)+")")
	else:
		get_tree().network_peer = networkENet
		Gb.dbg_print("Server ready to be created")

		networkENet.connect("peer_connected", self, "_Peer_Connected")
		networkENet.connect("peer_disconnected", self, "_Peer_Disconnected")
		
		upnpDiscoverResult = upnp.discover(3000, 2, "InternetGatewayDevice")
		if upnpDiscoverResult != upnp.UPNP_RESULT_SUCCESS:
			Gb.dbg_print("UPNP discovery failed (Code UPNPRESULT : "+str(upnpDiscoverResult)+").\nYou should open firewall port by yourself...")
		else : 
			upnpDeviceCount = upnp.get_device_count()
			if upnpDeviceCount==0 :
				Gb.dbg_print("Can't find an UPNP Internet Gateway.\nYou should open firewall port by yourself...")
			else :
				Gb.dbg_print("Found " + str(upnpDeviceCount) + " UPNP Device")
				upnpFirstDevice =  upnp.get_device(0)
				Gb.dbg_print("First UPNP device is " + upnpFirstDevice.description_url)
				upnpExternalIP = upnpFirstDevice.query_external_address()
				Gb.dbg_print("First UPNP external IP is " + upnpExternalIP)
				upnpPortResult = upnp.add_port_mapping(port)
				if upnpPortResult == upnp.UPNP_RESULT_SUCCESS:
					Gb.dbg_print("Successfully Upnp open port " + str(port) + " on gateway")
				else : 
					Gb.dbg_print("Warning : failed when trying to open port " + str(port) + " on gateway (ERROCODE: "+str (upnpPortResult)+")")

	Gb.my_player_number = 1 # I'am Host
	Gb.network_status = Gb.STATUS_SERVER
	

func StopServer():
	if upnpPortResult == upnp.UPNP_RESULT_SUCCESS:
		upnpPortDeleteResult = upnp.delete_port_mapping(port)
		if upnpPortDeleteResult == upnp.UPNP_RESULT_SUCCESS:
			Gb.dbg_print("Deleted Upnp open port " + str(port) + " on gateway")
		else : 
			Gb.dbg_print("Error while trying to deleted Upnp open port " + str(port) + " on gateway")
		
	networkENet.close_connection(0)
	get_tree().network_peer = null
	Gb.network_status = 0
	Gb.dbg_print("Server stopped")
	Gb.my_player_number = 0

	


func _Peer_Connected (peerId):
	Gb.dbg_print("Player Connected")
	networkENet.refuse_new_connections = true
	get_tree().change_scene("res://PlayGround.tscn")

func _Peer_Disconnected (peerId):
	Gb.dbg_print("Player Disconnected")
	networkENet.refuse_new_connections = false

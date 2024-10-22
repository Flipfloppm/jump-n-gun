extends Control

signal found_server(ip, port, roomInfo)
signal update_server(ip, port, roomInfo)
signal childServerJoin(ip)

var broadcastTimer: Timer
var RoomInfo = {"name":"name", "playerCount": 0, "open":true}
var broadcaster : PacketPeerUDP # Define our own UDP packet
var listener : PacketPeerUDP
@export var listenPort : int = 8911
@export var broadcastPort : int = 8912
@export var broadcastIP : String # This IP will be retrieved dynamically from the setup_server_broadcast function. 
@export var serverInfo : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	broadcastTimer = $BroadcastTimer
	# start listening for servers, no matter if this player hosts a game
	setup_listener()


func setup_listener():
	listener = PacketPeerUDP.new()	
	var ok = listener.bind(listenPort)
	if ok == OK:
		print("Listen to port: " + str(listenPort) + " Successful!")
		$ListenPortLabel.text = "Listening to port: True " + str(listenPort)
	else:
		# NOTE: when running 2 instances, only one will be able to bind. This is expected. 
		print("Failed to listen to port, error: " + str(ok))
		$ListenPortLabel.text = "Listening to port: False"

func setup_server_broadcast(serverName):
	RoomInfo["name"] = serverName
	RoomInfo["playerCount"] = GameManager.PLAYERS.size()
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	# Retrieve broadcast IP info on the specific machine.
	# NOTE: This section below is currently only tested on UNIX machines.
	# The behavior on windows machines is not yet tested. 
	var output = []
	var code = OS.execute("./get_ip", [], output, true)
	broadcastIP = output[0]
	print("retrived IP: " + broadcastIP)
	broadcaster.set_dest_address(broadcastIP, listenPort)
	
	# Start broadcasting on a specified port. 
	var ok = broadcaster.bind(broadcastPort)
	if ok == OK:
		print("Bound to broadcast port: " + str(broadcastPort) + " at " + str(broadcastIP) + " Successful!")
	else:
		print("Failed to broadcast port, error: " + str(ok))
	
	$BroadcastTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# check if we received any packets
	if listener.get_available_packet_count() > 0:
		var serverIP = listener.get_packet_ip()
		var serverPort = listener.get_packet_port()
		var receivedBytes = listener.get_packet()
		var data = receivedBytes.get_string_from_ascii()
		var roomInfo = JSON.parse_string(data)
		#print("serverIP: " + str(serverIP) + " serverPort: " + str(serverPort) + " roominfo: " + str(roomInfo))
		# Verify the input, if roomInfo's name is "", change it to the default case: New Server
		if roomInfo.name == "":
			roomInfo.name = "New Server"
			
		# update the info to the browser UI
		for child in $Panel/VBoxContainer.get_children():
			if child.name == roomInfo.name:
				if roomInfo.open == false:
					print("room removed", type_string(typeof(child)))
					child.get_node("IP").text = "Not hosting"	
					child.queue_free()
					return
				else:
					update_server.emit(serverIP, serverPort, roomInfo)
					child.get_node("PlayerCount").text = str(roomInfo.playerCount)
					child.get_node("IP").text = serverIP	
					return
		# add new info to browser if it is not closed
		if roomInfo.open == false:
			return
		else:
			var receivedServer = serverInfo.instantiate()
			receivedServer.name = roomInfo.name
			receivedServer.get_node("Name").text = roomInfo.name
			receivedServer.get_node("IP").text = serverIP
			receivedServer.get_node("PlayerCount").text = str(roomInfo.playerCount)
			$Panel/VBoxContainer.add_child(receivedServer)
			#receivedServer.serverBrowserJoin.connect(join_by_ip)
			found_server.emit(serverIP, serverPort, roomInfo)
				


func _on_broadcast_timer_timeout():
	#print("Broadcasting game")
	RoomInfo.playerCount = GameManager.PLAYERS.size()
	var data = JSON.stringify(RoomInfo)
	var packet = data.to_ascii_buffer() # doesn't work with japanese/chinese room info but this is small and efficient :)
	broadcaster.put_packet(packet) # send the packet through a queue
	
	
# Deprecated: the server_info's join button is directly handled by the server_select scene
## Tell the main control lobby that the specified join button is pressed.
#func join_by_ip(ip):
	#childServerJoin.emit(ip)


func _exit_tree():
	cleanup_browser()
	
func cleanup_browser():
	# close the room
	listener.close()
	$BroadcastTimer.stop()
	if broadcaster != null:
		broadcaster.close()
	print("cleanup browser: broadcast closed\n")

func broadcast_server_closed():
	# tell other potential clients the host has ended hosting.
	if broadcaster:
		RoomInfo.open = false
		var data = JSON.stringify(RoomInfo)
		var packet = data.to_ascii_buffer() # doesn't work with japanese/chinese room info but this is small and efficient :)
		broadcaster.put_packet(packet) # send the packet through a queue


extends Control

signal found_server(ip, port, roomInfo)
signal update_server(ip, port, roomInfo)
signal childServerJoin(ip)

var broadcastTimer: Timer
var RoomInfo = {"name":"name", "playerCount": 0}
var broadcaster : PacketPeerUDP # Define our own UDP packet
var listener : PacketPeerUDP
@export var listenPort : int = 8911
@export var broadcastPort : int = 8912
@export var broadcastIP : String = "192.168.1.255"
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
	broadcaster.set_dest_address(broadcastIP, listenPort)
	
	var ok = broadcaster.bind(broadcastPort)
	if ok == OK:
		print("Bound to broadcast port: " + str(broadcastPort) + " Successful!")
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
		print("serverIP: " + str(serverIP) + " serverPort: " + str(serverPort) + " roominfo: " + str(roomInfo))
		
		# update the info to the browser UI
		for child in $Panel/VBoxContainer.get_children():
			if child.name == roomInfo.name:
				update_server.emit(serverIP, serverPort, roomInfo)
				child.get_node("PlayerCount").text = str(roomInfo.playerCount)
				child.get_node("IP").text = serverIP	
				return
		
		var receivedServer = serverInfo.instantiate()
		receivedServer.name = roomInfo.name
		receivedServer.get_node("Name").text = roomInfo.name
		receivedServer.get_node("IP").text = serverIP
		receivedServer.get_node("PlayerCount").text = str(roomInfo.playerCount)
		$Panel/VBoxContainer.add_child(receivedServer)
		receivedServer.serverBrowserJoin.connect(join_by_ip)
		found_server.emit(serverIP, serverPort, roomInfo)
			


func _on_broadcast_timer_timeout():
	print("Broadcasting game")
	RoomInfo.playerCount = GameManager.PLAYERS.size()
	var data = JSON.stringify(RoomInfo)
	var packet = data.to_ascii_buffer() # doesn't work with japanese/chinese room info but this is small and efficient :)
	broadcaster.put_packet(packet) # send the packet through a queue
	
	
# Tell the main control lobby that the specified join button is pressed.
func join_by_ip(ip):
	childServerJoin.emit(ip)


func _exit_tree():
	cleanup_browser()
	
func cleanup_browser():
	listener.close()
	$BroadcastTimer.stop()
	if broadcaster != null:
		broadcaster.close()
		
		
	

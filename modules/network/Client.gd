extends Peer

func _ready():
	set_name("Server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")

func connect_to_server(ip, port):
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_client(ip, port)
	if not error:
		get_tree().network_peer = peer

func disconnect_():
	pass

func _server_disconnected():
	Terminal.addLog(str("Server disconnected!"))

func _connected_ok():
	Terminal.addLog(str("Connected successfully! New id: ", get_tree().get_network_unique_id()))

func _connected_fail():
	Terminal.addLog(str("Could not connect to the server!"))

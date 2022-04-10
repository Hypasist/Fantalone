extends Peer

func _ready():
	set_name("Client")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")

func connect_to_server(ip, port):
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_client(ip, port)
	if not error:
		get_tree().network_peer = peer

func disconnect_():
	Terminal.add_log(Debug.INFO, "Disconnecting from the server.")

signal server_disconnected()
func _server_disconnected():
	Terminal.add_log(Debug.INFO, "Server disconnected!")
	emit_signal("server_disconnected")

func _connected_ok():
	Terminal.add_log(Debug.INFO, "Connected successfully! New id: %d" % mod.Network.get_id())

func _connected_fail():
	Terminal.add_log(Debug.INFO, "Could not connect to the server!")

func connect_network_signal(_signal, _object, _method):
	for custom_signal in get_signal_list():
		if custom_signal["name"] == _signal:
			connect(_signal, _object, _method)

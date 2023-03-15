class_name ClientNetwork
extends PeerNetwork

# CONNECTION
func setup():
	return connect_to_server(mod.NetworkData.get_target_ip(), mod.NetworkData.SERVER_PORT)

func connect_to_server(ip, port):
	if connected:
		disconnect_()
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_client(ip, port)
	if error:
		return false
	else:
		mod.NetworkData.determine_my_ip()
		get_tree().network_peer = peer
		return true

func disconnect_():
	get_tree().network_peer = null
	Terminal.add_log(Debug.INFO, Debug.NETWORK, "Disconnecting from the server.")

# BASIC NETWORK SIGNALS
func _ready():
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")

signal server_disconnected()
func _server_disconnected():
	Terminal.add_log(Debug.INFO, Debug.NETWORK, "Server disconnected!")
	emit_signal("server_disconnected")

func _connected_ok():
	Terminal.add_log(Debug.INFO, Debug.NETWORK,  "Connected successfully! New id: %d" % mod.NetworkData.get_id())

func _connected_fail():
	Terminal.add_log(Debug.INFO, Debug.NETWORK,  "Could not connect to the server!")

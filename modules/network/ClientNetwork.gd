class_name ClientNetwork
extends PeerNetwork

# TARGET IP
var target_ip = "192.168.0.59"
func set_target_ip(ip):
	if ip.is_valid_ip_address():
		target_ip = ip
func get_target_ip():
	return target_ip

# CONNECTION
func setup():
	if is_online():
		disconnect_()
	connect_to_server(get_target_ip(), NetworkAPI.SERVER_PORT)
	online = true

func connect_to_server(ip, port):
	if connected:
		disconnect_()
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_client(ip, port)
	if not error:
		get_tree().network_peer = peer

func disconnect_():
	get_tree().network_peer = null
	online = false
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
	Terminal.add_log(Debug.INFO, Debug.NETWORK,  "Connected successfully! New id: %d" % mod.Network.get_id())

func _connected_fail():
	Terminal.add_log(Debug.INFO, Debug.NETWORK,  "Could not connect to the server!")

func connect_network_signal(_signal, _object, _method):
	for custom_signal in get_signal_list():
		if custom_signal["name"] == _signal:
			connect(_signal, _object, _method)


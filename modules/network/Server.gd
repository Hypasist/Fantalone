extends Peer

func _ready():
	set_name("Server")

func create_server(port, max_players):
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_server(port, max_players)
	
	if error:
		Terminal.add_log(Debug.ERROR, "Could not create the server! Error %d" % [error])
	else:
		get_tree().network_peer = peer
		Terminal.add_log(Debug.INFO, "Server (%d) created!" % [mod.Network.get_id()])

func disconnect_():
	Terminal.add_log(Debug.INFO, "Closing the server")
	get_tree().network_peer = null

var connected_clients = []
func send_peer_list():
	pass

func peer_connected(network_id):
	connected_clients.append(network_id)
	Terminal.add_log(Debug.INFO, "New client (%d) connected" % network_id)
	emit_signal("client_added", network_id)

func peer_disconnected(network_id):
	connected_clients.erase(network_id)
	Terminal.add_log(Debug.INFO, "Client (%d) disconnected" % network_id)
	emit_signal("client_removed", network_id)

func disconnect_client(network_id):
	Terminal.add_log(Debug.INFO, "Disconnecting client (%d)" % network_id)
	get_tree().network_peer.disconnect_peer(network_id)
	connected_clients.erase(network_id)
#	send_peer_list()

func disconnect_all_clients():
	for network_id in connected_clients.pop_front():
		Terminal.add_log(Debug.INFO, "Disconnecting client (%d)" % network_id)
		get_tree().network_peer.disconnect_peer(network_id)
#	send_peer_list()

func broadcast_to_peers(package):
	print("send rpc")
	rpc("joined_now_what", package)

signal client_added(network_id)
signal client_removed(network_id)
func connect_network_signal(_signal, _object, _method):
	for custom_signal in get_signal_list():
		if custom_signal["name"] == _signal:
			connect(_signal, _object, _method)

class_name ServerNetwork
extends EntityNetwork

var online = false
func is_online():
	return online
	
var connected_clients = []
func get_connected_clients():
	return connected_clients

func setup():
	if is_online():
		disconnect_()
	create_server(NetworkAPI.SERVER_PORT, MAX_PLAYERS)
	online = true

func create_server(port, max_players):
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_server(port, max_players)
	if error:
		Terminal.add_log(Debug.ERROR, Debug.NETWORK, "Could not create the server! Error %d" % [error])
	else:
		determine_my_ip()
		get_tree().network_peer = peer
		Terminal.add_log(Debug.INFO, Debug.NETWORK, "Server (%d) created! IP: %s" % [get_id(), ip])

func disconnect_():
	get_tree().network_peer = null
	online = false
	Terminal.add_log(Debug.INFO, Debug.NETWORK, "Closing the server")

func peer_connected(network_id):
	connected_clients.append(network_id)
	Terminal.add_log(Debug.INFO, Debug.NETWORK, "New client (%d) connected" % network_id)
	emit_signal("client_added", network_id)

func peer_disconnected(network_id):
	connected_clients.erase(network_id)
	Terminal.add_log(Debug.INFO, Debug.NETWORK, "Client (%d) disconnected" % network_id)
	emit_signal("client_removed", network_id)

func disconnect_client(network_id):
	Terminal.add_log(Debug.INFO, Debug.NETWORK, "Disconnecting client (%d)" % network_id)
	get_tree().network_peer.disconnect_peer(network_id)
	connected_clients.erase(network_id)

func disconnect_all_clients():
	for network_id in connected_clients.pop_front():
		Terminal.add_log(Debug.INFO, Debug.NETWORK, "Disconnecting client (%d)" % network_id)
		get_tree().network_peer.disconnect_peer(network_id)

signal client_added(network_id)
signal client_removed(network_id)
func connect_network_signal(_signal, _object, _method):
	for custom_signal in get_signal_list():
		if custom_signal["name"] == _signal:
			connect(_signal, _object, _method)
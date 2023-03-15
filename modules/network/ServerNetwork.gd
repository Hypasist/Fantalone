class_name ServerNetwork
extends PeerNetwork

func setup():
	create_server(mod.NetworkData.SERVER_PORT, GameData.MAX_PLAYERS)

func create_server(port, max_players):
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_server(port, max_players)
	if error:
		Terminal.add_log(Debug.ERROR, Debug.NETWORK, "Could not create the server! Error %d" % [error])
		return false
	else:
		mod.NetworkData.determine_my_ip()
		get_tree().network_peer = peer
		Terminal.add_log(Debug.INFO, Debug.NETWORK, \
			"Server (%d) created! IP: %s" % [get_id(), mod.NetworkData.get_ip()])
		return true

func disconnect_():
	get_tree().network_peer = null
	Terminal.add_log(Debug.INFO, Debug.NETWORK, "Closing the server")

func peer_connected(network_id):
	mod.NetworkData.add_connected_clients(network_id)
	Terminal.add_log(Debug.INFO, Debug.NETWORK, "New client (%d) connected" % network_id)
	emit_signal("client_added", network_id)

func peer_disconnected(network_id):
	mod.NetworkData.remove_connected_clients(network_id)
	Terminal.add_log(Debug.INFO, Debug.NETWORK, "Client (%d) disconnected" % network_id)
	emit_signal("client_removed", network_id)

func disconnect_client(network_id):
	Terminal.add_log(Debug.INFO, Debug.NETWORK, "Disconnecting client (%d)" % network_id)
	get_tree().network_peer.disconnect_peer(network_id)
	mod.NetworkData.remove_connected_clients(network_id)

func disconnect_all_clients():
	var clients = mod.NetworkData.get_connected_clients()
	for network_id in clients:
		disconnect_client(network_id)

signal client_added(network_id)
signal client_removed(network_id)

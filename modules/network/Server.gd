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
#		mod.Database.add_player_to_match()
		Terminal.add_log(Debug.INFO, "Server (%d) created!" % [mod.Network.get_id()])

func disconnect_():
	pass

var peer_list = []

func add_peer(id):
	peer_list.append(id)
func remove_peer(id):
	peer_list.erase(id)
func send_peer_list():
	pass

func peer_connected(id):
	add_peer(id)
	send_peer_list()

func peer_disconnected(id):
	remove_peer(id)
	send_peer_list()


func broadcast_to_peers(package):
	print("send rpc")
	rpc("joined_now_what", package)

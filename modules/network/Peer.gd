class_name Peer
extends Node

func _ready():
	print("peer ready?")
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")

func _peer_connected(id):
	Terminal.add_log(Debug.INFO, "New peer (%d) connected!" % mod.Network.get_id())
	peer_connected(id)

func peer_connected(id):
	rpc_id(id, "register_player", id)
	rpc("peer_connected_info", id)

remote func peer_connected_info(info):
	print("peer_connected_info: ", info, "     [", mod.Network.get_id(), "]")
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	print("info from ", id)
	
remote func register_player(info):
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	print("REGIESTER OUT  ", id)

func _peer_disconnected(id):
	Terminal.add_log(Debug.INFO, "Peer (%d) disconnected!" % id)

func peer_disconnected(id):
	pass

func terminate():
	Terminal.add_log(Debug.INFO, "Terminating peer (%d)" % mod.Network.get_id())
	get_tree().network_peer = null

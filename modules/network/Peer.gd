class_name Peer
extends Node

func _ready():
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")

func _peer_connected(network_id):
	peer_connected(network_id)

func peer_connected(network_id):
	Terminal.add_log(Debug.ALL, "Noticed (%d) connected to the server." % [network_id])

func _peer_disconnected(network_id):
	peer_disconnected(network_id)
	
func peer_disconnected(network_id):
	Terminal.add_log(Debug.ALL, "Noticed (%d) disconnected from the server." % [network_id])

func disconnect_():
	Terminal.add_log(Debug.ERROR, "Trying to disconnect base class!")

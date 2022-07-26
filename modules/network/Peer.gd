class_name Peer
extends Node

var ip = null

func _ready():
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")

func determine_ip():
	var ip_list = IP.get_local_addresses()
	for potential_ip in ip_list:
		if potential_ip.begins_with("192."):
			ip = potential_ip
			break

func _peer_connected(network_id):
	peer_connected(network_id)

func peer_connected(network_id):
	Terminal.add_log(Debug.ALL, Debug.NETWORK, "Noticed (%d) connected to the server." % [network_id])

func _peer_disconnected(network_id):
	peer_disconnected(network_id)
	
func peer_disconnected(network_id):
	Terminal.add_log(Debug.ALL, Debug.NETWORK, "Noticed (%d) disconnected from the server." % [network_id])

func disconnect_():
	Terminal.add_log(Debug.ERROR, Debug.NETWORK, "Trying to disconnect base class!")

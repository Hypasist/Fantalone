class_name EntityNetwork
extends Node

const MAX_PLAYERS = 8

func get_id():
	return get_tree().get_network_unique_id()

# CONNECTED STATUS
var connected = false;
func mark_connected():
	connected = true
func unmark_connected():
	connected = false
func is_connected_():
	return connected

# MY IP STATUS
var ip = null
func determine_my_ip():
	var ip_list = IP.get_local_addresses()
	for potential_ip in ip_list:
		if potential_ip.begins_with("192."):
			ip = potential_ip
			break
func get_ip():
	return ip

# BASIC NETWORK SIGNALS
func _ready():
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")

func _peer_connected(network_id):
	peer_connected(network_id)

func peer_connected(network_id):
	Terminal.add_log(Debug.ALL, Debug.NETWORK, "Noticed (%d) connected to the server." % [network_id])

func _peer_disconnected(network_id):
	peer_disconnected(network_id)
	
func peer_disconnected(network_id):
	Terminal.add_log(Debug.ALL, Debug.NETWORK, "Noticed (%d) disconnected from the server." % [network_id])

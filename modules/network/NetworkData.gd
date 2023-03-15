class_name NetworkData
extends Node

const LOCALHOST_IP = "127.0.0.1"
const SERVER_PORT = 1222
const SERVER_ID = 1
const INVALID_ID = -1

const Server = preload("res://modules/network/ServerNetwork.gd")
const Client = preload("res://modules/network/ClientNetwork.gd")
var peer = null
var peer_type = PEER_NONE
enum { PEER_NONE, PEER_SERVER, PEER_CLIENT }

func create_server():
	new_peer(PEER_SERVER)

func create_client():
	new_peer(PEER_CLIENT)
	
func new_peer(type):
	if peer:
		disconnect_self()
	match type:
		PEER_NONE:
			disconnect_self()
			peer_type = PEER_NONE
		PEER_SERVER:
			peer = Server.new()
			peer_type = PEER_SERVER
		PEER_CLIENT:
			peer = Client.new()
			peer_type = PEER_CLIENT
	if peer:
		add_child(peer)
		if peer.setup() == false:
			disconnect_self()

func is_multiplayer_game():
	return not (peer_type == PEER_NONE)

func is_host():
	return peer_type == PEER_SERVER

func is_client():
	return peer_type == PEER_CLIENT

func disconnect_self():
	if peer:
		peer.disconnect_()
		peer = null
		peer_type = PEER_NONE
		connected_clients = []

func get_id():
	return peer.get_id() if peer else null

# ------------------------------------ #
var connected_clients = []
func get_connected_clients():
	return connected_clients
func add_connected_clients(client):
	connected_clients.append(client)
func remove_connected_clients(client):
	connected_clients.erase(client)

# TARGET IP
var target_ip = "192.168.0.59"
func set_target_ip(ip):
	if ip.is_valid_ip_address():
		target_ip = ip
func get_target_ip():
	return target_ip

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

# admin_privileges
func is_admin():
	return is_host()


## ------ Redirections ------ ##
func disconnect_client(network_id):
	if is_host():
		peer.disconnect_client(network_id)

func connect_network_signal(_signal, _object, _method):
	if peer:
		peer.connect_network_signal(_signal, _object, _method)

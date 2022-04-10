extends Node

var SERVER_PORT = 22
var LOCALHOST_IP = "127.0.0.1"
var MAX_PLAYERS = 3

const SERVER_ID = 1
const Server = preload("res://modules/network/Server.gd")
const Client = preload("res://modules/network/Client.gd")
var peer = null

# id 1 is always a server
func get_id():
	return get_tree().get_network_unique_id()
func is_server():
	return get_tree().is_network_server()

func create_server():
	if peer:
		disconnect_()
	peer = Server.new()
	add_child(peer)
	peer.create_server(SERVER_PORT, MAX_PLAYERS)

func connect_to_server():
	if peer:
		disconnect_()
	peer = Client.new()
	add_child(peer)
	peer.connect_to_server(LOCALHOST_IP, SERVER_PORT)

func disconnect_():
	peer.disconnect_()
	get_tree().network_peer = null
	peer = null

func disconnect_client(network_id):
	if peer and peer is Server:
		peer.disconnect_client(network_id)

func broadcast_to_peers(package):
	print("SENDING BROADCAST")
	if peer is Server:
		peer.broadcast_to_peers(package)

remote func joined_now_what(package):
	print("eeeh? ", package)

func connect_network_signal(_signal, _object, _method):
	if peer:
		peer.connect_network_signal(_signal, _object, _method)

func disconnect_network_signals():
	pass

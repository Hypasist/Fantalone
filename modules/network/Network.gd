class_name Network
extends Node

var SERVER_PORT = 1222
var LOCALHOST_IP = "127.0.0.1"
var TARGET_SERVER_IP = "192.168.0.59"
var MAX_PLAYERS = 8

const SERVER_ID = 1
const INVALID_ID = -1

const Server = preload("res://modules/network/Server.gd")
const Client = preload("res://modules/network/Client.gd")
var peer = null

func get_id():
	return get_tree().get_network_unique_id()
func is_server():
	return get_tree().is_network_server()
func is_multidevice_game():
	return peer.get_connected_clients().empty() == false if is_server() else true

func get_ip():
	return peer.ip if peer else null
func set_target_ip(ip):
	if ip.is_valid_ip_address():
		TARGET_SERVER_IP = ip
func get_target_ip():
	return TARGET_SERVER_IP

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
	peer.connect_to_server(TARGET_SERVER_IP, SERVER_PORT)

func disconnect_():
	peer.disconnect_()
	get_tree().network_peer = null
	peer = null

func disconnect_client(network_id):
	if peer and peer is Server:
		peer.disconnect_client(network_id)

func connect_network_signal(_signal, _object, _method):
	if peer:
		peer.connect_network_signal(_signal, _object, _method)

func disconnect_network_signals():
	pass

class_name NetworkAPI
extends Node

const LOCALHOST_IP = "127.0.0.1"
const SERVER_PORT = 1222
const SERVER_ID = 1
const INVALID_ID = -1

static func is_host():
	return mod.ServerData.is_active()

static func is_client():
	return mod.ClientData.is_active()

static func is_admin():
	return mod.ClientData.LobbyData.is_admin()

static func is_online():
	if is_host():
		return mod.ServerData.Network.is_online()
	else:
		return mod.ClientData.Network.is_online()

static func get_ip():
	if is_host():
		return mod.ServerData.Network.get_ip()
	else:
		return mod.ClientData.Network.get_ip()

static func disconnect_lobby():
	if is_host():
		mod.ServerData.Network.disconnect_()
	else:
		mod.ClientData.Network.disconnect_()

static func get_id():
	if is_host():
		return mod.ServerData.Network.get_id()
	else:
		return mod.ClientData.Network.get_id()

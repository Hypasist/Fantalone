class_name ClientData
extends Node

onready var LobbyData = $ClientLobbyData
onready var MatchData = $ClientMatchData
onready var ObjectData = $ClientObjectData
onready var CommandData = $ClientCommandData

var active = false
func is_active():
	return active

func _ready():
	LobbyData.Data = self
	MatchData.Data = self
	ObjectData.Data = self
	CommandData.Data = self

func setup(setup_as_server):
	LobbyData.setup()
	if setup_as_server:
		LobbyData.client_identify_self()
	else:
		mod.LobbyNetworkAPI.setup()
		mod.MatchNetworkAPI.setup()
		mod.NetworkData.create_client()
	active = true

func update_lobby(package):
	LobbyData.setup(package)

func close():
	mod.NetworkData.disconnect_self()
	LobbyData.setup()
	active = false


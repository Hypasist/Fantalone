class_name ClientData
extends Node

onready var Network = $ClientNetwork
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
	ObjectData.set_display_setting(ObjectData.DISPLAY_ENABLED)
	CommandData.Data = self

func setup(setup_as_server):
	LobbyData.setup()
	if setup_as_server:
		LobbyData.set_admin_privileges(true)
	else:
		mod.LobbyNetworkAPI.setup()
		mod.MatchNetworkAPI.setup()
		LobbyData.set_admin_privileges(false)
		Network.connect_to_server()
	
	active = true
	mod.LobbyNetworkAPI.send_to_server(LobbyNetworkAPI.command.CLIENT_IDENTIFICATION, \
		mod.ClientData.Network.get_id(), \
		mod.ControllerData.get_player_name(), \
		mod.GameData.get_version())

func update_lobby(package):
	LobbyData.setup(package)

func close():
	Network
	LobbyData.setup()
	active = false

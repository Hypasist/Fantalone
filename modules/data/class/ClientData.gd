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
	CommandData.Data = self

func setup(is_multiplayer, is_admin):
	LobbyData.setup()
	if is_multiplayer:
		mod.LobbyNetworkAPI.setup()
		mod.MatchNetworkAPI.setup()
		Network.setup()
	LobbyData.set_admin_privileges(is_admin)
	
	active = true
	mod.LobbyNetworkAPI.send_to_server(LobbyNetworkAPI.command.CLIENT_IDENTIFY_TO_SERVER, \
		NetworkAPI.get_id(), \
		mod.OptionsData.get_player_name(), \
		mod.GameData.get_version())

func update_lobby(package):
	LobbyData.setup(package)

func close():
	Network.disconnect_()
	LobbyData.setup()
	active = false


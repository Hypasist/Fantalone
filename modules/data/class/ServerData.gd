class_name ServerData
extends Node

onready var Network = $ServerNetwork
onready var LobbyData = $ServerLobbyData
onready var MatchData = $ServerMatchData
onready var ObjectData = $ServerObjectData
onready var CommandData = $ServerCommandData

var active = false
func is_active():
	return active

func _ready():
	LobbyData.Data = self
	MatchData.Data = self
	ObjectData.Data = self
	CommandData.Data = self

func setup():
	mod.LobbyNetworkAPI.setup()
	mod.MatchNetworkAPI.setup()
	
	Network.setup()
	LobbyData.setup()
	active = true

func close():
	Network
	LobbyData.setup()
	active = false

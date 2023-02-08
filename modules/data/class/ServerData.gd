class_name ServerData
extends Node

onready var MatchData = $ServerMatchData
onready var LobbyData = $ServerLobbyData
onready var Network = $ServerNetwork

var active = false
func is_active():
	return active

func setup():
	mod.LobbyNetworkAPI.setup()
	mod.MatchNetworkAPI.setup()
	
	Network.setup()
	LobbyData.setup()
	MatchData.pre_setup(LobbyData, $ServerMatchData/ObjectData)
	active = true

func close():
	Network
	LobbyData.setup()
	active = false

extends Node

func _ready():
	mod.Game = self
	mod.Database = $Database
	mod.Network = $Network
	mod.MapEditor = $MapEditor
	mod.MapView = $MapView
	mod.UI = $UI
	mod.LocalLogic = $Logic/LocalLogic
	mod.Menu = $Menu
	mod.Logic = $Logic
	mod.MatchLogic = $Logic/MatchLogic
	mod.MatchData = $Database/MatchData
	mod.MatchNetwork = $Network/MatchNetwork
	mod.LobbyNetwork = $Network/LobbyNetwork
	mod.MovementLogic = $Logic/MovementLogic
	mod.LobbyLogic = $Logic/LobbyLogic
	mod.LobbyData = $Database/LobbyData
	mod.Debug = $Debug
	mod.PopupUI = $UI/PopupUI
	mod.SpellData = $Database/SpellData
	
	setup()
	mod.Menu.switch_screens(mod.Menu.main_menu)

func setup():
	mod.LocalLogic.identify_client()
	mod.Database.set_resolution(get_viewport().size)

func exit_game():
	get_tree().quit() 

# how about -- jedna scena rodzic dla tile i unit (logic moze display)
# reakcyjne delete free?

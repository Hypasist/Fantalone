extends Node

## TODO:
# animated tiles
# album for tiles
# *tiles with connections?? (water to grass e.g.?)
# long tap for help
#if zoom with pinch, move camera position
# when zooming, control where do you center

func _ready():
	mod.Game = self
	mod.Client = $Client
	mod.Database = $Database
	mod.Network = $Network
	mod.MapEditor = $MapEditor
	mod.MapView = $MapView
	mod.UI = $UI
	mod.Menu = $Menu
	mod.Logic = $Logic
	mod.Match = $Logic/MatchLogic
	mod.Lobby = $Logic/Lobby
	mod.Debug = $Debug
	mod.PopupHelper = $UI/PopupUI
	setup()
	mod.Menu.show_main_menu()

func setup():
	mod.Client.identify_client()
	mod.Database.set_resolution(get_viewport().size)

# how about -- jedna scena rodzic dla tile i unit (logic moze display)
# reakcyjne delete free?

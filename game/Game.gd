class_name Game
extends Node

func _ready():
	mod.Game = self
	
	# STATIC LOGIC LIBRARIES
	mod.HexMath = $StaticLogicLibraries/HexMath
	mod.LobbyLogic = $StaticLogicLibraries/LobbyLogic
	mod.FormationLogic = $StaticLogicLibraries/FormationLogic
	mod.ControllerLogic = $StaticLogicLibraries/ControllerLogic
	
	# LOCAL DATABASES
	mod.GameData = $LocalDatabases/GameData
	mod.ServerData = $LocalDatabases/ServerData
	mod.ClientData = $LocalDatabases/ClientData
	mod.ResourceData = $LocalDatabases/ResourceData
	mod.ControllerData = $LocalDatabases/ControllerData
	mod.OptionsData = $LocalDatabases/OptionsData
	mod.NetworkData = $LocalDatabases/NetworkData
	mod.MatchNetworkAPI = $LocalDatabases/NetworkData/MatchNetworkAPI
	mod.LobbyNetworkAPI = $LocalDatabases/NetworkData/LobbyNetworkAPI
	
	# GRAPHICS
	mod.Graphics = $Graphics
	mod.Debug = $Graphics/Debug
	mod.MapView = $Graphics/MapView
	mod.Menu = $Graphics/Menu
	mod.Popups = $Graphics/Popups
	mod.GameUI = $Graphics/GameUI
	
	# MAP EDITOR
	mod.MapEditor = $MapEditor
	
	# SETUP
	setup_game()

func setup_game():
	mod.ControllerData.identify_controller()
	mod.ControllerData.set_controlled_data(mod.ClientData)
	mod.Menu.switch_screens(Menu.main_menu)

func exit_game():
	get_tree().quit() 


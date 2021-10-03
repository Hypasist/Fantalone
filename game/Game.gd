extends Node

## TODO:
# animated tiles
# album for tiles
# *tiles with connections?? (water to grass e.g.?)
# long tap for help
#if zoom with pinch, move camera position

func _ready():
	Singletons.GameServant = $GameServant
	Singletons.GameOptions = $GameServant/GameOptions
	Singletons.MatchServant = $MatchServant
	Singletons.MatchOptions = $MatchServant/MatchOptions
	Singletons.InputServant = $InputServant
	Singletons.Game = self
	Singletons.Match = $Match
	Singletons.Logic = $Match/Logic
	Singletons.MapEditor = $MapEditor
	Singletons.Worldview = $Match/Worldview
	Singletons.Worldmap = $Match/Worldview/Worldmap
	Singletons.UI = $Match/UI
	
	$GameServant.setup()
	$MatchServant.setup()
	Terminal.addLog("Game's ready")
	
	showMainMenu()

func _process(delta):
	$Debug.set_text(str(Singletons.InputServant.get_longtap_time_left(), "  ", $InputServant/UserActionHandler.saved_action_info["current"]))
	pass

# MENU HANDLING

func showMainMenu():
	switchScreens(Singletons.menuScreens[Singletons.MAIN_SCREEN])
	Singletons.Match.hide()
	
func showMatch():
	if currentMenu:
		currentMenu.hide()
		currentMenu.queue_free()
	currentMenu = null
	Singletons.Match.show()

func _on_ScreenResolved(dataPackage):
	match dataPackage["command"]:
		Singletons.CHANGE_SCREEN:
			switchScreens(dataPackage["screenPath"])
		Singletons.START_MATCH:
			$MatchServant.start_game()
			showMatch()


var currentMenu = null
func switchScreens(path):
	var newMenu = load(path).instance()
	newMenu.connect("screen_resolved", self, "_on_ScreenResolved")
	add_child(newMenu)
	if currentMenu:
		currentMenu.hide()
		currentMenu.queue_free()
	currentMenu = newMenu

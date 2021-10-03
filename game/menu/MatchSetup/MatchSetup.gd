extends "res://game/menu/MenuScreenBase.gd"

var currentlyPickedColors = {}

func _ready():
	$P1.setup("Player_1", "Rzym", Singletons.colorList[0])
	$P1.connect("changeColor", self, "_changeColor")
	currentlyPickedColors[$P1] = 0
	
	$P2.setup("Player_2", "Galia", Singletons.colorList[1])
	$P2.connect("changeColor", self, "_changeColor")
	currentlyPickedColors[$P2] = 1


func _changeColor(object, value):
	if currentlyPickedColors.has(object):
		var newColor = currentlyPickedColors[object]
		while true:
			newColor = (newColor + value + Singletons.colorList.size()) % Singletons.colorList.size()
			if currentlyPickedColors.values().has(newColor) == false:
				object.set_color(Singletons.colorList[newColor])
				currentlyPickedColors[object] = newColor
				return
	
func _on_Cancel_pressed():
	resolveScreen(Singletons.CHANGE_SCREEN, null, Singletons.menuScreens[Singletons.MAIN_SCREEN])

func _on_StartGame_pressed():
	Singletons.MatchOptions.clear_player_options()
	Singletons.MatchOptions.add_player(0, $P1.get_current_name(),
									   $P1.get_current_color(), Singletons.MatchOptions.control.HUMAN_1)
	Singletons.MatchOptions.add_player(1, $P2.get_current_name(),
									   $P2.get_current_color(), Singletons.MatchOptions.control.HUMAN_2)
	resolveScreen(Singletons.START_MATCH, null, null)


extends MenuScreenBase

var occupied_colors = {}

func _ready():
	var colorlist = mod.Database.get_colorlist()
	
	$P1.setup("Player_1", "Rzym", colorlist[0])
	$P1.connect("change_color", self, "_on_change_color")
	occupied_colors[$P1] = 0
	
	$P2.setup("Player_2", "Galia", colorlist[1])
	$P2.connect("change_color", self, "_on_change_color")
	occupied_colors[$P2] = 1

func _on_change_color(object, value):
	var colorlist = mod.Database.get_colorlist()
	if occupied_colors.has(object):
		var new_color = occupied_colors[object]
		while true:
			new_color = (new_color + value + colorlist.size()) % colorlist.size()
			if occupied_colors.values().has(new_color) == false:
				object.set_color(colorlist[new_color])
				occupied_colors[object] = new_color
				return
	
func _on_Cancel_pressed():
	mod.Menu.switch_screens(mod.Menu.main_menu)

func _on_StartGame_pressed():
	mod.Database.clear_players_info()
	mod.Database.add_player_info(0, $P1.get_current_name(), $P1.get_current_color())
	mod.Database.add_player_info(1, $P2.get_current_name(), $P2.get_current_color())
	mod.Game.start_match()


extends MenuScreenBase

var PlayerOptions = preload("res://modules/display/menu/SingleplayerPlayerOptions.tscn")
var MAP_PLAYER_NUM = 2

var map_members = []
var occupied_colors = {}

var tmp_base = [["Rzym", 0, true], ["Galia", 1, false]]

func _ready():
	var colorlist = mod.GameData.get_color_list():
	
	for i in MAP_PLAYER_NUM:
		var setup = PlayerOptions.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
		setup.setup(tmp_base[i][2], tmp_base[i][0], colorlist[tmp_base[i][1]])
		setup.connect("change_color", self, "_on_change_color")
		occupied_colors[setup] = colorlist[tmp_base[i][1]]
		map_members.append(setup)
		$PlayerList.add_child(setup)

func clear_map():
	for member in map_members:
		member.free()
	map_members = []

func prepare_map(player_num):
	clear_map()
	for i in player_num:
		var player_options = PlayerOptions.new()

func _on_change_color(object, value):
	var colorlist = mod.GameData.get_color_list():
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
	pass


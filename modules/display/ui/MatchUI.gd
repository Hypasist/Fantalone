extends Control

var PlayerSummaryBar = preload("res://ui/PlayerSummaryBar.tscn")
var player_summary = {}

func setup():
	for player in mod.Database.get_players_number():
		var info = mod.Database.get_player_info_by_id(player)
		var summary_bar = PlayerSummaryBar.instance()
		$PlayerSummaryPanel.add_child(summary_bar)
		player_summary[info.id] = summary_bar
	update()
	show()

func update():
	for player in mod.Database.get_players_number():
		var info = mod.Database.get_player_info_by_id(player)
		var army_size = mod.Database.get_players_units_num(info.id)
		if army_size > 0:
			player_summary[info.id].update_bar(info.color, info.name_, army_size)
		else:
			delete_bar(info.id)

func delete_bar(id):
	player_summary[id].queue_free()
	player_summary.erase(id)

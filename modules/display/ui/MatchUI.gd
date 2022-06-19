extends Control

var PlayerSummaryBar = preload("res://ui/PlayerSummaryBar.tscn")
var player_summary = {}

func setup():
	for player in mod.LobbyData.get_players():
		var summary_bar = PlayerSummaryBar.instance()
		$PlayerSummaryPanel.add_child(summary_bar)
		player_summary[player.match_id] = summary_bar
	update()
	show()

func update():
	for player in mod.LobbyData.get_players():
		var army_size = mod.MatchData.get_players_units(player.match_id).size()
		if army_size > 0:
			player_summary[player.match_id].update_bar(player.color, player.nickname, army_size)
		else:
			delete_bar(player.match_id)

func delete_bar(match_id):
	if player_summary.has(match_id):
		player_summary[match_id].queue_free()
		player_summary.erase(match_id)

func _on_MatchMenuButton_pressed():
	mod.PopupUI.create_match_menu_popup()

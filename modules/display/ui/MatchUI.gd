extends Control

var PlayerSummaryBar = preload("res://ui/PlayerSummaryBar.tscn")
var player_summary = {}

func setup():
	for player in mod.LobbyData.get_members(LobbyMemberInfo.TYPE_PLAYER):
		var summary_bar = PlayerSummaryBar.instance()
		$PlayerSummaryPanel.add_child(summary_bar)
		player_summary[player.id] = summary_bar
	update()
	show()

func update():
	for player in mod.LobbyData.get_members(LobbyMemberInfo.TYPE_PLAYER):
		var army_size = mod.MatchData.get_players_units(player.id).size()
		if army_size > 0:
			player_summary[player.id].update_bar(player.color, player.nickname, army_size)
		else:
			delete_bar(player.id)

func delete_bar(id):
	player_summary[id].queue_free()
	player_summary.erase(id)

func _on_MatchMenuButton_pressed():
	mod.PopupUI.create_match_menu_popup()

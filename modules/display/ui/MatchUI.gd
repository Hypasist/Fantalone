class_name MatchUI
extends Control

var PlayerSummaryBar = preload("res://ui/PlayerSummaryBar.tscn")
var player_summary = {}
var spellcast_mode = false

func setup():
	delete_all()
	for player in mod.ClientData.LobbyData.get_players():
		var summary_bar = PlayerSummaryBar.instance()
		$PlayerSummaryPanel.add_child(summary_bar)
		player_summary[player.match_id] = summary_bar
	mod.GameUI.set_UI_action(GameUI.UI_ACTION_MOVE)
	update()

func update():
	update_end_turn_button()
	update_action_counter()
	for player in mod.ClientData.LobbyData.get_players():
		var turn_owner = (mod.ClientData.MatchData.get_turn_owner() == player.match_id)
		var army_size = mod.ClientData.MatchData.get_players_units_num(player.match_id)
		var mana = mod.ClientData.MatchData.get_player_mana(player.match_id)
		if army_size > 0:
			player_summary[player.match_id].update_bar(turn_owner, player.color, player.nickname, army_size, mana)
		else:
			delete_bar(player.match_id)

func update_end_turn_button():
	$TurnUI.update()

func update_action_counter():
	$TurnUI.update()

func delete_bar(match_id):
	if player_summary.has(match_id):
		player_summary[match_id].free()
		player_summary.erase(match_id)

func delete_all():
	for match_id in player_summary.keys():
		player_summary[match_id].free()
		player_summary.erase(match_id)

func _on_MatchMenuButton_pressed():
	mod.Popups.create_match_menu_popup()

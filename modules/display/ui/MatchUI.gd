extends Control

var PlayerSummaryBar = preload("res://ui/PlayerSummaryBar.tscn")
var player_summary = {}

func setup():
	delete_all()
	for player in mod.LobbyData.get_players():
		var summary_bar = PlayerSummaryBar.instance()
		$PlayerSummaryPanel.add_child(summary_bar)
		player_summary[player.match_id] = summary_bar
	update()
	show()

func update():
	update_move_counter()
	for player in mod.LobbyData.get_players():
		var turn_owner = mod.MatchLogic.get_turn_owner() == player.match_id
		var army_size = mod.MatchData.get_players_units(player.match_id).size()
		if army_size > 0:
			player_summary[player.match_id].update_bar(turn_owner, player.color, player.nickname, army_size)
		else:
			delete_bar(player.match_id)

func update_move_counter():
	if mod.LocalLogic.is_turn_owner_locally_present():
		$MoveCounter.set_text("%d out of %d moves left  " % [mod.MatchLogic.get_moves_left(), mod.MatchLogic.get_max_move_counter()])
		if mod.MatchLogic.get_move_counter() > 0:
			$EndTurnButton.set_disabled(false)
		else:
			$EndTurnButton.set_disabled(true)
	else:
		$MoveCounter.set_text("Waiting for opponent move: %d left  " % mod.MatchLogic.get_moves_left())
		

func delete_bar(match_id):
	if player_summary.has(match_id):
		player_summary[match_id].free()
		player_summary.erase(match_id)

func delete_all():
	for match_id in player_summary.keys():
		player_summary[match_id].free()
		player_summary.erase(match_id)

func _on_MatchMenuButton_pressed():
	mod.PopupUI.create_match_menu_popup()

func _on_SpellButton_pressed():
	mod.PopupUI.create_spell_menu_popup()

func _on_EndTurnButton_pressed():
	mod.MatchLogic.end_turn()

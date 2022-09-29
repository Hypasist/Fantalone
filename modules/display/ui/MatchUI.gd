class_name MatchUI
extends Control

var PlayerSummaryBar = preload("res://ui/PlayerSummaryBar.tscn")
var player_summary = {}
var spellcast_mode = false

func setup():
	delete_all()
	for player in mod.LobbyData.get_players():
		var summary_bar = PlayerSummaryBar.instance()
		$PlayerSummaryPanel.add_child(summary_bar)
		player_summary[player.match_id] = summary_bar
	turn_off_spell_targeting()
	update()

func update():
	update_end_turn_button()
	update_move_counter()
	for player in mod.LobbyData.get_players():
		var turn_owner = mod.MatchLogic.get_turn_owner() == player.match_id
		var army_size = mod.MatchData.get_players_units_num(player.match_id)
		var mana = mod.MatchData.get_player_mana(player.match_id)
		if army_size > 0:
			player_summary[player.match_id].update_bar(turn_owner, player.color, player.nickname, army_size, mana)
		else:
			delete_bar(player.match_id)

func update_end_turn_button():
	$TurnUI.update()

func update_move_counter():
	$TurnUI.update()

func delete_bar(match_id):
	if player_summary.has(match_id):
		player_summary[match_id].free()
		player_summary.erase(match_id)

func delete_all():
	for match_id in player_summary.keys():
		player_summary[match_id].free()
		player_summary.erase(match_id)

func turn_on_spell_targeting():
	spellcast_mode = true
	$SpellcastUI.show()
	$TurnUI.hide()
func turn_off_spell_targeting():
	spellcast_mode = false
	$SpellcastUI.hide()
	$TurnUI.show()
func is_spellcast_mode():
	return spellcast_mode

func spell_selected(spell_info):
	mod.LocalLogic.deselect_all_units()
	mod.LocalLogic.set_UI_mode(LocalLogic.UI_MODE_TILE)
	mod.LocalLogic.load_spell(spell_info)
	turn_on_spell_targeting()
func spell_deselected():
	mod.LocalLogic.set_UI_mode(LocalLogic.UI_MODE_UNIT)
	mod.LocalLogic.unload_spell()
	turn_off_spell_targeting()
func spell_casted():
	mod.LocalLogic.cast_spell()
	mod.MapView.execute_display_queues()
	spell_deselected()

func _on_MatchMenuButton_pressed():
	mod.PopupUI.create_match_menu_popup()

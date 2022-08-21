class_name LocalLogic
extends Node

enum clients { ai, desktop, mobile }
var client_type = null
func identify_client():
	match OS.get_name():
		"Android":
			client_type = clients.mobile
		"Windows":
			client_type = clients.desktop
		_:
			Terminal.add_log(Debug.ERROR, Debug.SYSTEM, "Cannot recognize OS!")


func get_client():
	return client_type
func has_graphic():
	return client_type is clients.desktop or client_type is client_type.mobile

func is_line_formation():
	var formation = mod.Logic.recognize_line_unit(selected_units)
	return formation.is_line() if formation else false

func is_move_valid(direction):
	var movement = mod.MovementLogic.recognize_movement_unit(selected_units, direction)
	if not movement.is_valid():
		Terminal.add_log(Debug.INFO, Debug.MATCH, "Invalid move: %s" % MovementInfo.invalid.keys()[movement.invalid_reason])
	return movement.is_valid()

func complete_movement(direction):
	var movement = mod.MatchLogic.verify_movement(selected_units, direction)
	if movement.is_valid():
		mod.MatchNetwork.execute_command(MatchNetwork.command.REQUEST_MOVE, selected_units, direction)
		deselect_all_units()
	else:
		Terminal.add_log(Debug.INFO, Debug.MATCH, "Invalid move: %s" % MovementInfo.invalid.keys()[movement.invalid_reason])

## INFORMING THE PLAYER ABOUT THE MOVE RESULTS:
## 	IF VALID:
##   	- the *destination* tile should have a color (OR ONLY BLUE??) of the incoming HEX
##		- if the *destination* tile is a lethal hex, present a skull
##	IF INVALID:
##		IF NO_REASON:
##			assert?
##		IF UNPASSABLE TERRAIN:
##			red cage on the unpassable terrain?, blue tile on any affected?
##		IF PUSHING OWN UNITS:
##			red cage on mentioned own unit, blue tile under any affected
##		IF FORMATION TOO WEAK:
##			RED CAGE on first invalid enemy hex, rest with blue tile under
##		IF TILE OCCUPIED:
##			red cage on tiles uccupied, blue tiles under own hexes

enum { UI_MODE_MENU, UI_MODE_UNIT, UI_MODE_TILE }
var current_UI_mode = UI_MODE_MENU
func get_UI_mode():
	return current_UI_mode
func set_UI_mode(mode):
	current_UI_mode = mode

func shorttap_handle():
	match get_UI_mode():
		UI_MODE_MENU:
			pass
		UI_MODE_UNIT:
			var unit = mod.UI.get_hovered_unit()
			if unit:
				if mod.MatchUI.is_spellcast_mode():
					$SpellcastLogic.new_unit_selected(unit)
				else:
					new_unit_selected(unit)
		UI_MODE_TILE:
			var tile = mod.UI.get_hovered_tile()
			if tile:
				if mod.MatchUI.is_spellcast_mode():
					$SpellcastLogic.new_tile_selected(tile)

func is_match_id_locally_present(match_id):
	var match_players = mod.LobbyData.get_players()
	for player in match_players:
		if player.match_id == match_id:
			if player.owner_lobby_member.network_id == mod.Network.get_id():
				return true
	return false

func load_spell(spell_info):
	$SpellcastLogic.load_spell(spell_info)
func unload_spell():
	$SpellcastLogic.unload_spell()

func is_turn_owner_locally_present():
	var owner = mod.MatchLogic.get_turn_owner()
	return is_match_id_locally_present(owner)

var selected_units = []
func setup():
	selected_units = []
func any_unit_selected():
	return selected_units.size() > 0

func select_unit(unit):
	selected_units.append(unit)
	unit.set_select(true)
	
func deselect_unit(unit):
	selected_units.erase(unit)
	unit.set_select(false)
	
func deselect_all_units():
	for unit in selected_units:
		unit.set_select(false)
	selected_units.clear()

func new_unit_selected(new_unit:UnitLogicBase):
	if not is_match_id_locally_present(new_unit.get_owner()): return
	if new_unit.has_tags([TagList.CANNOT_BE_SELECTED, TagList.CANNOT_MOVE]): return

	# IF WASN'T SELECTED BEFORE -- SELECT AND CHECK
	if new_unit.is_selected() == false && not selected_units.has(new_unit):
		select_unit(new_unit)

		# CHECK IF NEW UNIT MATCHES A LINE
		# 	IF NOT THEN IT IS THE FIRST ONE OF NEW LINE
		if is_line_formation() == false:
			deselect_all_units()
			select_unit(new_unit)

	# IF WAS SELECTED BEFORE -- DESELECT AND CHECK
	elif new_unit.is_selected() == true && selected_units.has(new_unit):
		deselect_unit(new_unit)
		if is_line_formation() == false:
			deselect_all_units()
	else:
		Terminal.add_log(Debug.ERROR, Debug.MATCH, "New_item_status/selected_list mismatch")


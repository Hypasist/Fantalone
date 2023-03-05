class_name ControllerData
extends Node

enum clients { ai, desktop, mobile }
var client_type = null

func identify_controller():
	client_type = mod.ControllerLogic.identify_platform()

var Data = null
func set_controlled_data(_Data):
	if Data:
		Data.ObjectData.set_display_setting(ObjectData.DISPLAY_DISABLED)
	Data = _Data
	Data.ObjectData.set_display_setting(ObjectData.DISPLAY_ENABLED)
func get_controlled_data():
	return Data

### PLAYERS SETTINGS
var autofinish_turn = true

### PLAYER PRIVATE SETTINGS
var player_name = "My name"
func get_player_name():
	return player_name
func set_player_name(new_name):
	player_name = new_name

## 
var selected_units = []
func setup():
	selected_units = []
func any_unit_selected():
	return selected_units.size() > 0
	
func new_unit_selected(new_unit:UnitLogicBase):
	if not Data.MatchData.is_match_id_locally_present(new_unit.get_owner()): return
	if new_unit.has_tags([TagList.CANNOT_BE_SELECTED, TagList.CANNOT_MOVE]): return

	# IF WASN'T SELECTED BEFORE -- SELECT AND CHECK
	if new_unit.is_selected() == false && not selected_units.has(new_unit):
		select_unit(new_unit)

		# CHECK IF NEW UNIT MATCHES A LINE
		# 	IF NOT THEN IT IS THE FIRST ONE OF NEW LINE
		if mod.FormationLogic.is_line_formation(selected_units) == false:
			deselect_all_units()
			select_unit(new_unit)

	# IF WAS SELECTED BEFORE -- DESELECT AND CHECK
	elif new_unit.is_selected() == true && selected_units.has(new_unit):
		deselect_unit(new_unit)
		if mod.FormationLogic.is_line_formation(selected_units) == false:
			deselect_all_units()
	else:
		Terminal.add_log(Debug.ERROR, Debug.MATCH, "New_item_status/selected_list mismatch")

func select_unit(unit):
	selected_units.append(unit)
#	unit.get_hex().get_tile().set_select(true)
	unit.set_select(true)

func deselect_unit(unit):
	selected_units.erase(unit)
#	unit.get_hex().get_tile().set_select(false)
	unit.set_select(false)
	
func deselect_all_units():
	for unit in selected_units:
#		unit.get_hex().get_tile().set_select(false)
		unit.set_select(false)
	selected_units.clear()

func is_selected_move_valid(direction):
	return FormationLogic.is_move_valid(Data, selected_units, direction)

func complete_movement(direction):
	var movement = Data.MatchData.verify_movement(selected_units, direction)
	if movement.is_valid():
		#mod.MatchNetwork.execute_command(MatchNetwork.command.REQUEST_MOVE, selected_units, direction)
		Data.CommandData.new_command(LogCmdNewMovement, {"units":movement.get_unit_list(), "direction":movement.get_direction(), "caller":movement.get_owner()})
		deselect_all_units()
	else:
		Terminal.add_log(Debug.INFO, Debug.MATCH, "Invalid move: %s" % movement.get_invalid_string())

func update_display():
	mod.MapView.execute_display_queues()
	mod.GameUI.update_ui()

func end_turn():
	var match_id = Data.MatchData.get_turn_owner()
	var actions_left = Data.MatchData.get_actions_left()
	if not Data.MatchData.is_match_id_locally_present(match_id):
		return ErrorInfo.new(ErrorInfo.invalid.not_your_turn)
	elif Data.MatchData.get_action_counter() == 0:
		return ErrorInfo.new(ErrorInfo.invalid.need_at_least_one_move)
	Data.CommandData.new_command(LogCmdFinishTurn, {"caller":match_id, "actions_left":actions_left})
	Data.CommandData.new_command(LogCmdConcludeAndSend, {"caller":match_id})

## TODO:
# Need to verify commands via their inner methods before adding them to queue

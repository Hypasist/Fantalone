class_name MatchLogic
extends Node

const max_move_counter = 2
var move_counter = 0
var current_turn_owner = -1
func get_turn_owner():
	return current_turn_owner
func set_turn_owner(match_id):
	move_counter = 0
	current_turn_owner = match_id
func get_move_counter():
	return move_counter
func get_max_move_counter():
	return max_move_counter
func get_moves_left():
	return max_move_counter - move_counter

func determine_next_turn_owner():
	var lobby_players = mod.LobbyData.get_players()
	var map_size = mod.LobbyData.get_map_player_size()
	
	if not lobby_players.empty():
		if current_turn_owner == -1:
			for i in map_size:
				for player in lobby_players:
					if player.match_id == i and mod.MatchData.get_players_units(player.match_id).size() > 0:
						current_turn_owner = player.match_id
						return current_turn_owner
		else:
			for i in map_size:
				var candidate = (current_turn_owner + i + 1) % map_size
				for player in lobby_players:
					if player.match_id == candidate and mod.MatchData.get_players_units(player.match_id).size() > 0:
						current_turn_owner = player.match_id
						return current_turn_owner
			return current_turn_owner


func start_match():
	current_turn_owner = -1
	mod.Menu.hide_menu()
	mod.LocalLogic.set_UI_mode(LocalLogic.UI_MODE_UNIT)
	mod.MapView.load_map()
	mod.MatchData.setup_match()
	mod.UI.setup()
	mod.MatchNetwork.setup()


func stop_match():
	Terminal.add_log(Debug.INFO, Debug.MATCH, "Match stopped.")
	mod.Menu.show_menu()
	mod.LocalLogic.set_UI_mode(LocalLogic.UI_MODE_MENU)
	mod.MapView.erase_map()
	mod.UI.hide_match_ui()
	mod.Network.disconnect_()
	mod.Menu.switch_screens(mod.Menu.main_menu)

func new_turn():
	determine_next_turn_owner()
	Terminal.add_log(Debug.INFO, Debug.MATCH, "New turn started. Current player: %d." % get_turn_owner())
	propagate_effects(get_turn_owner())
	mod.MatchNetwork.execute_command(MatchNetwork.command.BROADCAST_TURN_OWNER)

func verify_movement(unit_list, direction):
	var movement = mod.MovementLogic.recognize_movement_unit(unit_list, direction)
	if not movement.is_valid():
		return movement
	else:
		for unit in unit_list:
			if unit.get_owner() != mod.MatchLogic.get_turn_owner():
				movement.invalid_move(MovementInfo.invalid.not_your_turn)
				return movement
		return movement
		
func make_move(unit_list, direction) -> bool:
	var movement = mod.MovementLogic.make_move_unit(unit_list, direction)
	move_counter += 1
	if not movement:
		return false
	if movement.is_valid() == false:
		Terminal.add_log(Debug.ERROR, Debug.SYSTEM, "Something went horribly wrong, cannot make move: %s" % MovementInfo.invalid.keys()[movement.invalid_reason])
		return false
	else:
		mod.MapView.execute_display_queues()
	action_done()
	return true


func propagate_effects(match_id):
	var units = mod.MatchData.get_players_units(match_id)
	for unit in units:
		unit.propagate_effects()

func execute_log_cmd(log_cmd_list):
	var command_list = []
	for log_cmd in log_cmd_list:
		var cmd_name = LogCmd.unpack(log_cmd[0])
		var param = mod.Database.unpack_unit(log_cmd[1])
		var cmd = cmd_name.new(param)
#		print("%s  %s" % [LogCmd.pack_dictionary[cmd_name], param._name_id])
		cmd.execute()
	mod.MapView.execute_display_queues()
	action_done()

func action_done():
	if move_counter == max_move_counter && mod.Database.is_autofinish_turn():
		request_end_turn()
	mod.MatchData.cleanup_objects()
	mod.UI.update_ui()

func check_endgame_conditions():
	var alive_players = 0
	for player in mod.LobbyData.get_players():
		if mod.MatchData.get_players_units(player.match_id).size() > 0:
			alive_players += 1
	return true if alive_players <=1 else false

func is_game_over():
	if check_endgame_conditions():
		mod.MatchData.pause_game()
		mod.PopupUI.create_custom_popup("Game finished!\n%s won!" % "Someone", ["Continue"], [true], self, "_on_finish_popup_handler")
		return true
	else:
		return false

func end_turn(match_id):
	var movement = MovementInfo.new(null)
	if match_id != mod.MatchLogic.get_turn_owner():
		movement.invalid_move(MovementInfo.invalid.not_your_turn)
	elif move_counter == 0:
		movement.invalid_move(MovementInfo.invalid.need_at_least_one_move)
	else:
		new_turn()
	return movement

func request_end_turn():
	var match_id = mod.MatchLogic.get_turn_owner()
	mod.MatchNetwork.execute_command(MatchNetwork.command.REQUEST_END_TURN, match_id)

func _on_finish_popup_handler(value):
	stop_match()


func client_execute_move(unit_pack, directory):
	if not mod.Network.is_server():
		var unit_list = mod.Database.unpack_unit_ids(unit_pack)
		mod.MatchLogic.make_move(unit_list, directory)
		mod.MatchNetwork.execute_command(MatchNetwork.command.SEND_MATCH_HASH_STATUS)

class_name MatchLogic
extends Node

var current_turn_owner = -1
func get_turn_owner():
	return current_turn_owner

func set_turn_owner(match_id):
	current_turn_owner = match_id

func determine_next_turn_owner():
	var lobby_players = mod.LobbyData.get_players()
	if not lobby_players.empty():
		if current_turn_owner == -1:
			current_turn_owner = lobby_players[0].match_id
			return current_turn_owner
		else:
			lobby_players += lobby_players # doubling the array 
			var current_owner_found = false
			for player in lobby_players:
				if current_owner_found:
					current_turn_owner = player.match_id
					return current_turn_owner
				if player.match_id == current_turn_owner:
					current_owner_found = true


func start_match():
	mod.Menu.hide_menu()
	mod.MapView.setup()
	mod.UI.setup()
	mod.MatchNetwork.setup()

func verify_move(unit_list, direction):
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
	if not movement:
		return false
	if movement.is_valid() == false:
		# TODO: TUTAJ INVALID REASON HANDLING
		return false
	else:
		mod.MapView.execute_display_queues()
	mod.Database.cleanup_objects()
	mod.UI.update_ui()
	return true

func wake_up_units(match_id):
	var units = mod.MatchData.get_players_units(match_id)
	var log_cmd_list = []
	for unit in units:
		if unit.is_tired():
			log_cmd_list.append([LogCmd.pack(LogCmdWakeUp), mod.Database.pack_unit(unit)])
	if not log_cmd_list.empty():
		mod.MatchNetwork.execute_command(MatchNetwork.command.BROADCAST_LOG_CMD, log_cmd_list)

func execute_log_cmd(log_cmd_list):
	var command_list = []
	for log_cmd in log_cmd_list:
		var cmd_name = LogCmd.unpack(log_cmd[0])
		var param = mod.Database.unpack_unit(log_cmd[1])
		var cmd = cmd_name.new(param)
		print(cmd, cmd_name, param)
		cmd.execute()
	mod.MapView.execute_display_queues()

func new_turn():
	determine_next_turn_owner()
	wake_up_units(get_turn_owner())
	mod.MatchNetwork.execute_command(MatchNetwork.command.BROADCAST_TURN_OWNER, get_turn_owner())

func move_confirmed(unit_list, direction):
	mod.MatchNetwork.execute_command(MatchNetwork.command.BROADCAST_MOVE, unit_list, direction)
	new_turn()

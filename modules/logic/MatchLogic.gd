class_name MatchLogic
extends Node

var current_turn_owner = -1
func get_turn_owner():
	return current_turn_owner

func set_turn_owner(id):
	current_turn_owner = id

func determine_next_turn_owner():
	var lobby_players = mod.LobbyData.get_members(LobbyMemberInfo.TYPE_PLAYER)
	if not lobby_players.empty():
		if current_turn_owner == -1:
			current_turn_owner = lobby_players[0].id
			return current_turn_owner
		else:
			lobby_players += lobby_players # doubling the array 
			var current_owner_found = false
			for player in lobby_players:
				if current_owner_found:
					current_turn_owner = player.id
					return current_turn_owner
				if player.id == current_turn_owner:
					current_owner_found = true


func start_match():
	mod.Menu.hide_menu()
	mod.MapView.setup()
	mod.UI.setup()
	mod.MatchNetwork.setup()

func verify_move(unit_list, direction, id):
	var movement = mod.MovementLogic.recognize_movement_unit(unit_list, direction)
	if not movement.is_valid():
		return movement
	else:
		if mod.MatchLogic.get_turn_owner() == id:
			return movement
		else:
			movement.invalid_move(MovementInfo.invalid.not_your_turn)
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

func new_turn():
	determine_next_turn_owner()
	mod.MatchNetwork.execute_command(MatchNetwork.command.BROADCAST_TURN_OWNER, get_turn_owner())

func move_confirmed(unit_list, direction):
	mod.MatchNetwork.execute_command(MatchNetwork.command.BROADCAST_MOVE, unit_list, direction)
	new_turn()

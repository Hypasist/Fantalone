class_name MatchData
extends Node

var Data = null

# TURN OWNER

var current_turn_owner = -1
func get_turn_owner():
	return current_turn_owner
func set_turn_owner(match_id):
	reset_action_counter()
	current_turn_owner = match_id
func reset_turn_owner():
	current_turn_owner = -1
func determine_next_turn_owner():
	mod.MatchLogic.determine_next_turn_owner(Data)


## CURRENT OWNER ACTIONS

var action_counter = 0
func get_action_counter():
	return action_counter
func modify_action_counter(action_cost):
	action_counter += action_cost
func set_action_counter(action_counter_):
	action_counter = action_counter_
func reset_action_counter():
	action_counter = 0
func get_actions_left():
	return get_player_max_actions(get_turn_owner()) - get_action_counter()

## ACTIONS

var MAXIMUM_ACTION_LIMIT = 3
var player_max_actions = {}
func get_player_max_actions(match_id):
	return player_max_actions[match_id] if player_max_actions.has(match_id) else 0


## PLAYER PRESENT INDICATORS

func is_turn_owner_locally_present():
	return is_match_id_locally_present(get_turn_owner())

func is_match_id_locally_present(match_id):
	for player in Data.LobbyData.get_players():
		if player.match_id == match_id:
			if player.owner_lobby_member.network_id == mod.ClientData.Network.get_id():
				return true
	return false

## SETUP

func setup(package:Dictionary={}):
	Data.ObjectData.remove_all_objects()
	var player_list = Data.LobbyData.get_players()
	for player in player_list:
		player_mana[player.match_id] = STARTING_MANA
	for player in player_list:
		player_max_actions[player.match_id] = MAXIMUM_ACTION_LIMIT
	if package:
		MatchDataPackage.unpack(Data, package)


## MANA

var MAXIMUM_MANA_LIMIT = 20
var MANA_REGEN = 20
var STARTING_MANA = 8
var player_mana = {}
func get_player_mana(match_id):
	return player_mana[match_id] if player_mana.has(match_id) else 0
func get_players_mana():
	return player_mana
func modify_player_mana(match_id, mana_cost):
	if player_mana.has(match_id): player_mana[match_id] += mana_cost
func set_players_mana(package):
	player_mana = package

## EFFECTS

# players effect

## Garbage collector 

func cleanup_marked_objects():
	var unit_marked_list = []
	for unit in Data.ObjectData.get_unit_list():
		if unit.is_marked_to_delete():
			unit_marked_list.append(unit)
	Data.ObjectData.remove_unit_list(unit_marked_list)
	
	var tile_marked_list = []
	for tile in Data.ObjectData.get_tile_list():
		if tile.is_marked_to_delete():
			tile_marked_list.append(tile)
	Data.ObjectData.remove_tile_list(tile_marked_list)


## MIGRATED FROM MATCHLOGIC __

func new_turn():
	determine_next_turn_owner()
	Terminal.add_log(Debug.INFO, Debug.MATCH, "New turn started. Current player: %d." % get_turn_owner())
	propagate_effects(get_turn_owner())
	mod.GameUI.update_ui()
	mod.MatchNetwork.execute_command(MatchNetworkAPI.command.SERVER_BROADCAST_MATCH_STATUS)

func verify_movement(unit_list, direction):
	var movement = mod.FormationLogic.recognize_movement_unit(unit_list, direction)
	if not movement.is_valid():
		return movement
	else:
		for unit in unit_list:
			if unit.get_owner() != get_turn_owner():
				movement.invalid_move(ErrorInfo.invalid.not_your_turn)
				return movement
		return movement

func verify_cost(action_cost, mana_cost):
	if action_cost > get_actions_left():
		return ErrorInfo.new(ErrorInfo.invalid.not_enough_action_points)
	if mana_cost > get_player_mana(get_turn_owner()):
		return ErrorInfo.new(ErrorInfo.invalid.not_enough_mana_points)
	return ErrorInfo.new()

func execute_cost(action_cost, mana_cost):
	modify_action_counter(action_cost)
	get_player_mana(get_turn_owner())

func execute_movement(unit_list, direction):
	var movement = mod.FormationLogic.recognize_movement_unit(unit_list, direction)
	for command in movement.get_command_list():
		command.execute()
	return movement

static func propagate_effects(match_id):
	var units = mod.MatchData.get_players_units(match_id)
	for unit in units:
		unit.propagate_effects()

func action_done():
	if action_counter == mod.MatchData.get_player_max_actions(get_turn_owner()) \
	   && mod.Database.is_autofinish_turn():
		pass
#		request_end_turn()


## Redirects
func get_all_units():
	return MatchLogic.get_all_units(Data)
func get_all_tiles():
	return MatchLogic.get_all_tiles(Data)
func get_neighbour_hex(hex, direction):
	return MatchLogic.get_neighbour_hex(Data, hex, direction)
func get_players_units_num(match_id):
	return MatchLogic.get_players_units_num(Data, match_id)

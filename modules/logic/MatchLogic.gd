class_name MatchLogic
extends Node

static func determine_next_turn_owner(lobbydata, matchdata):
	var lobby_players = lobbydata.get_players()
	var map_size = lobbydata.get_map_player_size()
	
	if not lobby_players.empty():
		if matchdata.current_turn_owner == -1:
			for i in map_size:
				for player in lobby_players:
					if player.match_id == i and get_players_units(matchdata, player.match_id).size() > 0:
						return matchdata.set_turn_owner(player.match_id)
		else:
			for i in map_size:
				var candidate = (matchdata.current_turn_owner + i + 1) % map_size
				for player in lobby_players:
					if player.match_id == matchdata.candidate and matchdata.get_players_units(player.match_id).size() > 0:
						return matchdata.set_turn_owner(player.match_id)

## Both

static func get_object_by_name(matchdata, object_name):
	var object = get_unit_by_name(matchdata, object_name)
	if null == object:
		object = get_tile_by_name(matchdata, object_name)
	return object


## UNIT SELECTION

static func get_all_units(matchdata):
	var return_array = []
	for unit in matchdata.ObjectData.get_unit_list():
		if not unit.is_marked_to_delete():
			return_array.append(unit)
	return return_array

static func get_players_units(matchdata, match_id):
	var return_array = []
	for unit in get_all_units(matchdata):
		if unit.get_owner() == match_id:
			return_array.append(unit)
	return return_array

static func get_players_units_num(matchdata, match_id):
	return get_players_units(matchdata, match_id).size()

static func get_unit_by_name(matchdata, unit_name):
	for unit in get_all_units(matchdata):
		if unit.get_name_id() == unit_name:
			return unit
	return null

## TILES SELECTION

static func get_all_tiles(matchdata):
	var return_array = []
	for tile in matchdata.ObjectData.get_tile_list():
		if not tile.is_marked_to_delete():
			return_array.append(tile)
	return return_array

static func get_tile_by_name(matchdata, tile_name):
	for tile in get_all_tiles(matchdata):
		if tile.get_name_id() == tile_name:
			return tile
	return null


#func execute_log_cmd(log_cmd_list):
#	var command_list = []
#	for log_cmd in log_cmd_list:
#		var cmd_name = LogCmd.unpack(log_cmd[0])
#		var param = mod.Database.unpack_unit(log_cmd[1])
#		var cmd = cmd_name.new(param)
##		print("%s  %s" % [LogCmd.pack_dictionary[cmd_name], param._name_id])
#		cmd.execute()
#	mod.MapView.execute_display_queues()
##	action_done()

func check_endgame_conditions():
	var alive_players = 0
	for player in mod.LobbyData.get_players():
		if mod.MatchData.get_players_units(player.match_id).size() > 0:
			alive_players += 1
	return true if alive_players <=1 else false

func is_game_over():
	if check_endgame_conditions():
		mod.MatchData.pause_game()
		mod.Popups.create_custom_popup("Game finished!\n%s won!" % "Someone", ["Continue"], [true], self, "_on_finish_popup_handler")
		return true
	else:
		return false

func request_end_turn():
	var match_id = mod.MatchData.get_turn_owner()
	var actions_left = mod.MatchData.get_actions_left()
	mod.CommandQueue.new_command(LogCmdFinishTurn, {"caller":match_id, "actions_left":actions_left})
	mod.CommandQueue.new_command(LogCmdConcludeAndSend, {"caller":match_id})

func _on_finish_popup_handler(value):
	mod.ClientData.MatchData.stop_match()

#func client_execute_move(unit_pack, directory):
#	if not mod.Network.is_server():
#		var unit_list = mod.Database.unpack_unit_ids(unit_pack)
#		mod.MatchLogic.make_move(unit_list, directory)
#		mod.MatchNetwork.execute_command(MatchNetwork.command.SEND_MATCH_HASH_STATUS)

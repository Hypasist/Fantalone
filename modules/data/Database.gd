extends Node

# GLOBALS ACCESS
func get_color(id):
	return $GameParameters.colorList[id]
func get_colorlist():
	return $GameParameters.colorList
func get_player_name():
	return $GameParameters.player_name
func set_player_name(name):
	$GameParameters.player_name = name

# ACCESS FUNCTIONS:
func is_autofinish_turn():
	return $GameParameters.autofinish_turn

func set_resolution(resolution):
	$GameParameters.set_resolution(resolution)
func get_map_resolution():
	return $GameParameters.map_resolution
func get_game_resolution():
	return $GameParameters.game_resolution

func get_tilesize():
	return $GameParameters.get_tilesize()

func get_min_map_scale():
	return $GameParameters.min_map_scale
func get_max_map_scale():
	return $GameParameters.max_map_scale
	
func get_min_map_boundaries():
	return $MatchParameters.min_map_boundaries
func get_max_map_boundaries():
	return $MatchParameters.max_map_boundaries
func set_min_map_boundaries(value:Vector2):
	$MatchParameters.min_map_boundaries = value
func set_max_map_boundaries(value:Vector2):
	$MatchParameters.max_map_boundaries = value

# MATCH
func clear_players_info():
	$MatchParameters.clear_players_info()
func add_player_info(id:int, name_:String, color:Color):
	$MatchParameters.add_player_info(id, name_, color)
func get_player_info(id):
	return $MatchParameters.get_player_info(id)
func get_players_number():
	return $MatchParameters.players_number
func get_current_turn_owner():
	return $MatchParameters.current_turn_owner
func set_current_turn_owner(id):
	$MatchParameters.current_turn_owner = id
func get_players_units_num(id):
	return $MatchData.get_players_units_num(id)
func report_new_object(class_):
	return $MatchData.report_new_object(class_)

# RESOURCES
func get_unique_name(class_):
	return $MatchData.get_unique_name(class_)
func get_resource_by_name(name):
	return $ResourceData.get_resource(name)
func register_new_unit(unit):
	$MatchData.register_new_unit(unit)
func register_new_tile(tile):
	$MatchData.register_new_tile(tile)
func cleanup_objects():
	$MatchData.cleanup_objects()

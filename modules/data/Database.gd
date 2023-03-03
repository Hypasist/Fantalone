class_name Database
extends Node

# ACCESS FUNCTIONS:
func is_autofinish_turn():
	return $GameParameters.autofinish_turn
func set_autofinish_turn(value):
	$GameParameters.autofinish_turn = value


# MATCH
func get_players_units_num(match_id):
	return $MatchData.get_players_units_num(match_id)
func report_new_object(class_):
	return $MatchData.report_new_object(class_)
func setup_new_match():
	$MatchData.setup_new_match()

# PACKING FUNCTIONS
func pack_unit_ids(unit_list):
	var ids = []
	for unit in unit_list:
		ids.append(unit._name_id)
	return ids

func unpack_unit_ids(unit_ids):
	var units = []
	for unit in mod.MatchData.get_all_units():
		if unit_ids.has(unit._name_id):
			units.append(unit)
	return units

func pack_unit(unit):
	return unit._name_id
func unpack_unit(unit_id):
	for unit in mod.MatchData.get_all_units():
		if unit_id == unit._name_id:
			return unit

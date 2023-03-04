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

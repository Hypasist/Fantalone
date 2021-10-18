extends Node

func new_selected(new_object):
	$MovementLogic.new_selected(new_object)

func considerMoving(direction):
	return $MovementLogic.considerMoving(direction)

func makeMove(moveInfo):
	$MovementLogic.makeMove(moveInfo)

func finishMove():
	$MatchLogic.finishMove()

func any_unit_selected():
	return $MovementLogic.any_selected()

func deselectAllUnits():
	$MovementLogic.deselectAllUnits()

func tireSelectedUnits():
	$MovementLogic.tireSelectedUnits()
	
func untireAllPlayerUnits(player_id):
	$MovementLogic.untireAllPlayerUnits(player_id)

func startMatch():
	$MatchLogic.startMatch()

func get_current_turn_owner():
	return $MatchLogic.turn_owner_index

func get_all_player_units(player_id):
	var group_name = Singletons.MatchOptions.match_options["players"][player_id]["unit_group_name"]
	return get_tree().get_nodes_in_group(group_name)

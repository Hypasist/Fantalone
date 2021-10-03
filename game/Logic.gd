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


func startMatch():
	$MatchLogic.startMatch()

func get_current_turn_owner():
	return $MatchLogic.turn_owner_index

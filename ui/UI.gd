extends Control

func set_turn_owner(owner_name):
	$TurnIndicator.set_text(str("Tura gracza: ", owner_name))
func set_scoreboard(_string):
	$ScoreBoard.set_text(_string)
func set_turns_left(turns_left):
	match turns_left:
		0:
			$TurnCounter.set_text(str("no turns left"))
		1:
			$TurnCounter.set_text(str(turns_left, " turn left"))
		_:
			$TurnCounter.set_text(str(turns_left, " turns left"))

# ARROW CONTROL
func set_no_direction_arrow(position):
	$MovementArrow.set_direction_arrow(position, 6)
func set_invalid_arrow(position):
	$MovementArrow.set_direction_arrow(position, 7)
func set_direction_arrow(position, direction):
	$MovementArrow.set_direction_arrow(position, direction)
func clear_direction():
	$MovementArrow.hide()
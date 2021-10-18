extends Node

var players = null
var turn_order = []
var turn_owner_index = null

var moves_left = 0
const MOVES_PER_TURN = 2


func startMatch():
	players = Singletons.MatchOptions.match_options["players"]
	for player in Singletons.MatchOptions.match_options["players"]:
		turn_order.append(player)
		
	startNewTurn(0)

func updateUI():
	var _string = ""
	_string += str("R: ", Singletons.Logic.get_all_player_units(0).size(), "\n")
	_string += str("G: ", Singletons.Logic.get_all_player_units(1).size(), "\n")
	Singletons.UI.set_scoreboard(_string)
	Singletons.UI.set_turns_left(moves_left)

func startNewTurn(new_owner):
	turn_owner_index = new_owner
	moves_left = MOVES_PER_TURN
	Singletons.Logic.untireAllPlayerUnits(turn_owner_index)
	
	Singletons.UI.set_turns_left(moves_left)
	Singletons.UI.set_turn_owner(players[turn_owner_index]["name"])
	updateUI()

func finishTurn():
	startNewTurn((turn_owner_index + 1) % turn_order.size())

func finishMove():
	moves_left -= 1
	updateUI()
	if moves_left <= 0 && Singletons.GameOptions.is_autofinish_turn():
		startNewTurn((turn_owner_index + 1) % turn_order.size())

# Signal handling
func _on_EndTurnButton_pressed():
	finishTurn()

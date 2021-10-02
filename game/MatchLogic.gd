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

func startNewTurn(new_owner):
	turn_owner_index = new_owner
	moves_left = MOVES_PER_TURN
	Singletons.UI.set_turns_left(moves_left)
	Singletons.UI.set_turn_owner(players[turn_owner_index]["name"])

func endTurn():
	var _string = ""
	_string += str("R: ", get_tree().get_nodes_in_group(Singletons.MatchOptions.match_options["players"][0]["unit_group_name"]).size(), "\n")
	_string += str("G: ", get_tree().get_nodes_in_group(Singletons.MatchOptions.match_options["players"][1]["unit_group_name"]).size(), "\n")
	Singletons.UI.set_scoreboard(_string)
	moves_left -= 1
	if moves_left <= 0:
		startNewTurn((turn_owner_index + 1) % turn_order.size())

# Signal handling
func _on_EndTurnButton_pressed():
	endTurn()

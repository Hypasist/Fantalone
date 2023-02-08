class_name LogCmdBase
extends Reference

const SERVER_CALL = -1
var caller = null
var action_cost = 0
var mana_cost = 0

enum states { new, pending, verified, done }
var state = null

func _init(param_dictionary={"caller":null}):
	caller = param_dictionary["caller"] if param_dictionary.has("caller") else null
	set_state(states.new)

func set_state(_state):
	state = _state
func get_state():
	return state
func is_verified():
	return state >= states.verified
func is_done():
	return state >= states.done

func get_command_name():
	return null

func pack_command():
	pass

func unpack_command(_record):
	pass

func verify():
	return mod.MatchLogic.verify_cost(action_cost, mana_cost)

func execute():
	mod.MatchLogic.execute_cost(action_cost, mana_cost)
	mod.MatchData.cleanup_marked_objects()
	mod.GameUI.update_ui()

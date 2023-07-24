class_name LogCmdBase
extends Reference

const SERVER_CALL = -1
var name = "Default LogCmd Name"
var Data = null
var caller = null # match_id of caller
var action_cost = 0
var mana_cost = 0
var subcommand = false

enum states { new, pending, verified, done }
var state = null

func _init(param_dictionary={"caller":null}):
	Data = param_dictionary["data"] if param_dictionary.has("data") else null
	caller = param_dictionary["caller"] if param_dictionary.has("caller") else null
	set_state(states.new)

func set_state(_state):
	state = _state
func get_state():
	return state
func get_state_name():
	return states.keys()[state]
func is_verified():
	return state >= states.verified
func is_done():
	return state >= states.done

func get_command_name():
	return name

func pack_command():
	pass

static func unpack_command(Data, pack):
	return pack

func verify():
	return Data.MatchData.verify_cost(action_cost, mana_cost)

func execute():
	Data.MatchData.execute_cost(action_cost, mana_cost)
	Data.MatchData.cleanup_marked_objects()

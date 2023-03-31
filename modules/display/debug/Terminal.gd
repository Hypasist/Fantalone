class_name Debug
extends Node

# debug levels, from least to most vocal
enum DebugLevel {DEBUG_NONE, DEBUG_ERROR, DEBUG_INFO, DEBUG_ALL}
const NONE = DebugLevel.DEBUG_NONE
const ERROR = DebugLevel.DEBUG_ERROR
const INFO = DebugLevel.DEBUG_INFO
const ALL = DebugLevel.DEBUG_ALL

enum DebugFlag {DEBUG_ALL_FLAGS, DEBUG_SYSTEM, DEBUG_NETWORK, DEBUG_LOBBY_NETWORK, DEBUG_MATCH_NETWORK, DEBUG_QUEUE_NETWORK, DEBUG_MENUS, DEBUG_MAP, DEBUG_LOBBY, DEBUG_INPUT, DEBUG_DISPLAY_CMD, DEBUG_LOGIC_CMD, DEBUG_EFFECT, DEBUG_MATCH}
const ALL_FLAGS = DebugFlag.DEBUG_ALL_FLAGS
const LOBBY = DebugFlag.DEBUG_LOBBY
const MENUS = DebugFlag.DEBUG_MENUS
const INPUT = DebugFlag.DEBUG_INPUT
const DISPLAY_CMD = DebugFlag.DEBUG_DISPLAY_CMD
const LOGIC_CMD = DebugFlag.DEBUG_LOGIC_CMD
const EFFECT = DebugFlag.DEBUG_EFFECT
const MAP = DebugFlag.DEBUG_MAP
const MATCH = DebugFlag.DEBUG_MATCH
const SYSTEM = DebugFlag.DEBUG_SYSTEM
const NETWORK = DebugFlag.DEBUG_NETWORK
const LOBBY_NETWORK = DebugFlag.DEBUG_LOBBY_NETWORK
const MATCH_NETWORK = DebugFlag.DEBUG_MATCH_NETWORK
const QUEUE_NETWORK = DebugFlag.DEBUG_QUEUE_NETWORK

## -------------------------------- ##
const debug_flag_array = { # NONE / ERROR / INFO / ALL
	ALL_FLAGS:			ERROR, \
	LOBBY: 				NONE, \
	MENUS: 				NONE, \
	INPUT: 				NONE, \
	DISPLAY_CMD: 		NONE, \
	LOGIC_CMD: 			NONE, \
	EFFECT: 			NONE, \
	MAP: 				NONE, \
	MATCH: 				NONE, \
	SYSTEM: 			NONE, \
	NETWORK: 			NONE, \
	LOBBY_NETWORK: 		NONE, \
	MATCH_NETWORK: 		ALL, \
	QUEUE_NETWORK: 		ALL}
## -------------------------------- ##
var event_log_limit = 3
var breakpoint_on_error = false
var to_console = true
var event_log = []


func clear_log():
	event_log.clear()

func add_log(msg_level, msg_flag, msg_string):
	if not (DebugLevel.values().has(msg_level) and DebugFlag.values().has(msg_flag)):
		return
	
	if (msg_level <= debug_flag_array[msg_flag]) || (msg_level <= debug_flag_array[ALL_FLAGS]):
		msg_string = "[%s %s] %s" % [DebugFlag.keys()[msg_flag], DebugLevel.keys()[msg_level], msg_string]
	
		if to_console:
			print(msg_string)
		else:
			event_log.push_back(msg_string)
			if event_log.size() > event_log_limit:
				event_log.pop_front()
	
	if breakpoint_on_error and msg_level == ERROR:
		breakpoint

func get_latest_logs():
	if event_log.size() == 0: return "-- no logs --"
	var logs = ""
	for i in event_log.size():
		logs += event_log[i]
		logs += "\n"
	return logs

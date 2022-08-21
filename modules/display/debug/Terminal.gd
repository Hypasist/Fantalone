class_name Debug
extends Node

const event_log_limit = 3
# debug levels, from least to most vocal
enum DebugLevel {DEBUG_NONE, DEBUG_ERROR, DEBUG_INFO, DEBUG_ALL}
const NONE = DebugLevel.DEBUG_NONE
const ERROR = DebugLevel.DEBUG_ERROR
const INFO = DebugLevel.DEBUG_INFO
const ALL = DebugLevel.DEBUG_ALL
var debug_level = DebugLevel.DEBUG_ALL

enum DebugFlag {DEBUG_SYSTEM, DEBUG_NETWORK, DEBUG_MENUS, DEBUG_MAP, DEBUG_LOBBY, DEBUG_INPUT, DEBUG_DISPLAY_CMD, DEBUG_LOGIC_CMD, DEBUG_EFFECT, DEBUG_MATCH}
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
const debug_flag_array = [ MATCH, SYSTEM, LOGIC_CMD, DISPLAY_CMD, EFFECT ]

var breakpoint_on_error = false
var to_console = true
var event_log = []


func clear_log():
	event_log.clear()

func add_log(msg_level, msg_flag, msg_string):
	if DebugLevel.values().has(msg_level) && msg_level <= debug_level \
		&& debug_flag_array.has(msg_flag):
		msg_string = "[%s] %s" % [DebugLevel.keys()[msg_level], msg_string]
	
		if to_console:
			print(msg_string)
		else:
			event_log.push_back(msg_string)
			if event_log.size() > event_log_limit:
				event_log.pop_front()
	
	if breakpoint_on_error:
		breakpoint

func get_latest_logs():
	if event_log.size() == 0: return "-- no logs --"
	var logs = ""
	for i in event_log.size():
		logs += event_log[i]
		logs += "\n"
	return logs

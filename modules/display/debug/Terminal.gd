class_name Debug
extends Node

const event_log_limit = 6
# debug levels, from least to most vocal
enum DebugLevel {DEBUG_NONE, DEBUG_ERROR, DEBUG_INFO, DEBUG_ALL}
const NONE = DebugLevel.DEBUG_NONE
const ERROR = DebugLevel.DEBUG_ERROR
const INFO = DebugLevel.DEBUG_INFO
const ALL = DebugLevel.DEBUG_ALL

var debug_level = DebugLevel.DEBUG_ALL
var to_console = true
var event_log = []


func clear_log():
	event_log.clear()

func add_log(msg_level, msg_string):
	if DebugLevel.values().has(msg_level) && msg_level <= debug_level:
		msg_string = "[%s] %s" % [DebugLevel.keys()[msg_level], msg_string]
	
		if to_console:
			print(msg_string)
		else:
			event_log.push_back(msg_string)
			if event_log.size() > event_log_limit:
				event_log.pop_front()

func get_latest_logs():
	if event_log.size() == 0: return "-- no logs --"
	var logs = ""
	for i in event_log.size():
		logs += event_log[i]
		logs += "\n"
	return logs

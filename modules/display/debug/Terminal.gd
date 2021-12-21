extends Node

const eventLogLimit = 6
var eventLog = []

var to_console = true


func clearLog():
	eventLog.clear()


func addLog(string):
	if to_console:
		print(string)
	else:
		eventLog.push_back(string)
		if eventLog.size() > eventLogLimit:
			eventLog.pop_front()

func getLatestLogs():
	if eventLog.size() == 0: return "-- no logs --"
	var logs = ""
	for i in eventLog.size():
		logs += eventLog[i]
		logs += "\n"
	return logs

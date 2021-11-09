extends Node

const eventLogLimit = 6
var eventLog = []

func clearLog():
	eventLog.clear()


func addLog(string):
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

extends Label

const eventLogLimit = 6
var eventLog = []

func clearLog():
	eventLog.clear()
	displayEvents()


func addLog(string):
	eventLog.push_back(string)
	if eventLog.size() > eventLogLimit:
		eventLog.pop_front()
	displayEvents()


func displayEvents():
	var displayedText = ""
	
	for i in eventLog.size():
		displayedText += eventLog[i]
		displayedText += "\n"
	
	set_text(displayedText)
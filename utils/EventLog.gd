extends Label

func displayEvents():
	set_text(Terminal.getLatestLogs())
	
func _process(_delta):
	displayEvents()
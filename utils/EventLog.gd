extends Label

func displayEvents():
	set_text(Terminal.get_latest_logs())
	
func _process(_delta):
	displayEvents()

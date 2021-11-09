extends Timer

var longtap_timelimit_ms = 700.0

# LONG TAP TIMER FUNCTIONS
func start_timer():
	start(longtap_timelimit_ms/1000)
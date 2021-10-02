extends Node

func get_longtap_time_left():
	return str($UserActionHandler/LongTapTimer.get_time_left())

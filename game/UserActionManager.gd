extends Node

export(int,"off","on") var debug_verbose = 0
export(int,"disabled","single_drag") var movement_gesture = 1

enum actionState {none, longtap_waiting, longtap_confirmed, drag_confirmed}
var saved_action_info = {	"current": actionState.none,
							"position": null,
							"distance": null}
var longtap_timelimit_ms = 700.0

func _unhandled_input(event):
	if (event is InputEventSingleScreenDrag and movement_gesture == 1):
		emit_drag_active(event.relative)
	elif event is InputEventSingleScreenTap:
		handle_shorttap(event.position)
	elif event is InputEventSingleScreenTouch:
		if event.pressed:
			handle_tap(event.position)
		else:
			handle_untap()

# LONG TAP TIMER FUNCTIONS
func start_longtap_timer():
	$LongTapTimer.start(longtap_timelimit_ms/1000)

func stop_longtap_timer():
	$LongTapTimer.stop()

func _on_LongTapTimer_timeout():
	if saved_action_info["current"] == actionState.longtap_waiting:
		saved_action_info["current"] = actionState.longtap_confirmed
		handle_longtap_active(saved_action_info["position"])
	else:
		clean_states()

func _on_MapActionHandler_map_action_taken():
		clean_states()

# ACTION SIGNALS
signal action_shorttap(position)
signal action_longtap_active(position)
signal action_longtap_stopped
signal action_drag_active(position, relative)
signal action_drag_stopped
signal action_cancel

# ACTION HANDLERS
func clean_states():
	saved_action_info["current"] = actionState.none
	saved_action_info["position"] = null
	saved_action_info["distance"] = null
	stop_longtap_timer()
	emit_signal("action_cancel")

func handle_shorttap(position):
	if debug_verbose: Terminal.addLog(str("Tap P:", position))
	emit_signal("action_shorttap", position)

func handle_longtap_active(position):
	if debug_verbose: Terminal.addLog("Tap Long:")
	emit_signal("action_longtap_active", position)

func handle_longtap_stop():
	clean_states()
	emit_signal("action_longtap_stopped")

func emit_drag_active(relative):
	if(saved_action_info["current"] == actionState.longtap_waiting):
		saved_action_info["current"] = actionState.drag_confirmed
		saved_action_info["relative"] = relative
	elif(saved_action_info["current"] == actionState.drag_confirmed):
		saved_action_info["relative"] += relative
	else:
		return # ignore if actionState.none or actionState.longtap_confirmed
	
	if debug_verbose: Terminal.addLog(str("Drag P:", saved_action_info["position"], " R:", saved_action_info["relative"]))
	emit_signal("action_drag_active", saved_action_info["position"], saved_action_info["relative"])

func handle_drag_stop():
	clean_states()
	emit_signal("action_drag_stopped")

func handle_tap(_position):
	saved_action_info["current"] = actionState.longtap_waiting
	saved_action_info["position"] = _position
	start_longtap_timer()

func handle_untap():
	if(saved_action_info["current"] == actionState.longtap_confirmed):
		handle_longtap_stop()
	elif(saved_action_info["current"] == actionState.drag_confirmed):
		handle_drag_stop()
	else:
		clean_states()
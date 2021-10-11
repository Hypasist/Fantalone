extends Node

export(int,"off","on") var debug_verbose = 0
export(int,"disabled","single_drag") var movement_gesture = 1
export(int,"disabled","pinch") var zoom_gesture = 1
export(int,"disabled","twist") var rotation_gesture = 1
export(int,"disabled","multi_drag", "single_drag") var scroll_gesture = 2

enum actionState {none, longtap_waiting, longtap_confirmed, drag_confirmed}
var saved_action_info = {	"current": actionState.none,
							"position": null,
							"distance": null}
var longtap_timelimit_ms = 700.0

func _unhandled_input(event):
	if (event is InputEventSingleScreenDrag and movement_gesture == 1 \
		and Singletons.Logic.any_unit_selected()):
			emit_drag_active(event.relative)
	elif event is InputEventSingleScreenTap:
		handle_shorttap(event.position)
	elif event is InputEventSingleScreenTouch:
		if event.pressed:
			handle_tap(event.position)
		else:
			handle_untap()
			
	elif (event is InputEventMultiScreenDrag and scroll_gesture == 1) or \
	 event is InputEventSingleScreenDrag and scroll_gesture == 2 \
	 and not Singletons.Logic.any_unit_selected():
		handle_scroll(event)
	elif event is InputEventScreenPinch and zoom_gesture == 1:
		handle_zoom(event)
	elif event is InputEventScreenTwist and rotation_gesture == 1:
		handle_rotate(event)

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
		stop_longtap_timer()
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

# MAP HANDLERS
func handle_scroll(event):
	if debug_verbose:
		Terminal.addLog("Scroll R:" + str(event.relative))
	Singletons.Worldview.scroll(event.relative)
	clean_states()

func handle_zoom(event):
	if debug_verbose:
		Terminal.addLog("Zoom P:" + str(event.position) + " R:" + str(event.relative) + " D:" + str(event.distance))
	Singletons.Worldview.zoom(event.position, event.relative, event.is_step)
	clean_states()

func handle_rotate(event):
	clean_states()

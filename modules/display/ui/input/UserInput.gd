extends Node

export(int,"off","on") var debug_verbose_map = 0
export(int,"off","on") var debug_verbose_units = 1
export(int,"disabled","single_drag") var movement_gesture = 1
export(int,"disabled","pinch") var zoom_gesture = 1
export(int,"disabled","twist") var rotation_gesture = 1
export(int,"disabled","multi_drag", "single_drag") var scroll_gesture = 1

enum actionState {none, longtap_waiting, longtap_confirmed, drag_confirmed}
var saved_action = actionState.none
var saved_position = null
var saved_relative = null

# ACTION HANDLERS
func clean_states():
	saved_action = actionState.none
	saved_position = null
	saved_relative = null
	$LongTapTimer.stop()
	$PlayerAction.action_cancel()

func _unhandled_input(event):
	if event is InputEventSingleScreenTap:
		handle_shorttap(event)
	elif event is InputEventSingleScreenTouch:
		handle_tap(event) if event.pressed else handle_untap()
	elif (event is InputEventSingleScreenDrag
		and movement_gesture == 1):
		handle_drag_ambiguous(event)
	elif (event is InputEventMultiScreenDrag
		and scroll_gesture == 1):
		handle_drag_ambiguous(event)
	elif (event is InputEventSingleScreenDrag
		and scroll_gesture == 2):
		handle_drag_ambiguous(event)
	elif (event is InputEventScreenPinch
		and zoom_gesture == 1):
		handle_pinch(event)
	elif (event is InputEventScreenTwist
		and rotation_gesture == 1):
		handle_twist(event)

# ACTION HANDLERS
func handle_shorttap(event):
	if debug_verbose_units: Terminal.add_log(Debug.ALL, Debug.INPUT, "Tap P: %f %f" % [event.position.x, event.position.y])
	$PlayerAction.action_shorttap(event.position)

func handle_tap(event):
	saved_action = actionState.longtap_waiting
	saved_position = event.position
	$LongTapTimer.start_timer()

func handle_untap():
	if(saved_action == actionState.longtap_confirmed):
		if debug_verbose_units:  Terminal.add_log(Debug.ALL, Debug.INPUT, "LongTap stop")
		$PlayerAction.action_longtap_stopped()
	elif(saved_action == actionState.drag_confirmed):
		if debug_verbose_units: Terminal.add_log(Debug.ALL, Debug.INPUT, "Drag stop")
		$PlayerAction.action_drag_stopped(saved_position, saved_relative)
	clean_states()
	
func _on_LongTapTimer_timeout():
	if saved_action == actionState.longtap_waiting:
		saved_action = actionState.longtap_confirmed
		if debug_verbose_units: Terminal.add_log(Debug.ALL, Debug.INPUT, "LongTap P:%f %f" % saved_position)
		$PlayerAction.action_longtap(saved_position)
	else:
		clean_states()

func handle_drag_ambiguous(event):
	if mod.ControllerData.any_unit_selected():
		handle_drag_unit(event)
	else:
		handle_drag_map(event)
		
func handle_drag_unit(event):
	if(saved_action == actionState.longtap_waiting):
		saved_action = actionState.drag_confirmed
		saved_relative = event.relative
		$LongTapTimer.stop()
	elif(saved_action == actionState.drag_confirmed):
		saved_relative += event.relative
	else:
		return # ignore if actionState.none or actionState.longtap_confirmed
	if debug_verbose_units: Terminal.add_log(Debug.ALL, Debug.INPUT, "Drag P: %f %f  R: %f %f" % \
		[saved_position.x, saved_position.y, saved_relative.x, saved_relative.y])
	$PlayerAction.action_drag(saved_position, saved_relative)

func handle_drag_map(event): # aka scroll
	if debug_verbose_map: Terminal.add_log(Debug.ALL, Debug.INPUT, "Scroll R: %f %f" % event.relative)
	$PlayerAction.action_scroll(event.relative)
	clean_states()

func handle_pinch(event): # aka zoom
	if debug_verbose_map: Terminal.add_log(Debug.ALL, Debug.INPUT, "Zoom P: %f %f  R: %f %f" % [event.position, event.relative])
	$PlayerAction.action_zoom(event.position, event.relative, event.is_step)
	clean_states()

func handle_twist(_event): # aka rotate
	$PlayerAction.action_rotate()
	clean_states()
	
	
	

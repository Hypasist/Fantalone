extends Node

export(int,"off","on") var debug_verbose_map = 1
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
	if not mod.UI.map_control_enabled: return
		
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
	if debug_verbose_units: Terminal.addLog(str("Tap P:", event.position))
	$PlayerAction.action_shorttap(event.position)

func handle_tap(event):
	saved_action = actionState.longtap_waiting
	saved_position = event.position
	$LongTapTimer.start_timer()

func handle_untap():
	if(saved_action == actionState.longtap_confirmed):
		if debug_verbose_units: Terminal.addLog(str("LongTap stop"))
		$PlayerAction.action_longtap_stopped()
	elif(saved_action == actionState.drag_confirmed):
		if debug_verbose_units: Terminal.addLog(str("Drag stop"))
		$PlayerAction.action_drag_stopped(saved_position, saved_relative)
	clean_states()
	
func _on_LongTapTimer_timeout():
	if saved_action == actionState.longtap_waiting:
		saved_action = actionState.longtap_confirmed
		if debug_verbose_units: Terminal.addLog(str("LongTap P:", saved_position))
		$PlayerAction.action_longtap(saved_position)
	else:
		clean_states()

func handle_drag_ambiguous(event):
	if mod.Logic.any_unit_selected():
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
	if debug_verbose_units: Terminal.addLog(str("Drag P:", saved_position, " R:", saved_relative))
	$PlayerAction.action_drag(saved_position, saved_relative)


func handle_drag_map(event): # aka scroll
	if debug_verbose_map: Terminal.addLog("Scroll R:" + str(event.relative))
	$PlayerAction.action_scroll(event.relative)
	clean_states()

func handle_pinch(event): # aka zoom
	if debug_verbose_map: Terminal.addLog("Zoom P:" + str(event.position) + " R:" + str(event.relative))
	$PlayerAction.action_zoom(event.position, event.relative, event.is_step)
	clean_states()

func handle_twist(event): # aka rotate
	$PlayerAction.action_rotate()
	clean_states()
	
	
	
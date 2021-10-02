extends Node

export(int,"disabled","pinch") var zoom_gesture = 1
export(int,"disabled","twist") var rotation_gesture = 1
export(int,"disabled","multi_drag") var movement_gesture = 1
export(int,"off","on") var debug_verbose = 0

signal map_action_taken
func _unhandled_input(event):
	if (event is InputEventMultiScreenDrag and movement_gesture == 1):
		if debug_verbose:
			Terminal.addLog("MultiDrag P:" + str(event.position) + " R:" + str(event.relative) + " S:" + str(event.speed))
		emit_signal("map_action_taken")
		Singletons.Worldview.scroll(event.relative) 
		
	elif event is InputEventScreenPinch and zoom_gesture == 1:
		if debug_verbose:
			Terminal.addLog("Pinch P:" + str(event.position) + " R:" + str(event.relative) + " D:" + str(event.distance) + " S:" + str(event.speed))
		emit_signal("map_action_taken")
		Singletons.Worldview.zoom(event.position, event.relative, event.is_step)
		
	elif event is InputEventScreenTwist and rotation_gesture == 1:
		emit_signal("map_action_taken")
		rotate(event)

#func _zoom(event):
#	var li = event.distance
#	var lf = event.distance + event.relative
#	var zi = zoom.x
#
#	var zf = (li*zi)/lf
#	if zf == 0: return
#	var zd = zf - zi
#
#	if zf <= MIN_ZOOM and sign(zd) < 0:
#		zf =MIN_ZOOM
#		zd = zf - zi
#	elif zf >= MAX_ZOOM and sign(zd) > 0:
#		zf = MAX_ZOOM
#		zd = zf - zi
#
#	var from_camera_center_pos = event.position - get_camera_center_offset()
#	position -= (from_camera_center_pos*zd).rotated(rotation)
#	zoom = zf*Vector2.ONE
	
	
func rotate(event):
	pass
#	var fccp = (event.position - get_camera_center_offset()) # from_camera_center_pos = fccp
#	var fccp_op_rot =  -fccp.rotated(event.relative)
#	position -= ((fccp_op_rot + fccp)*zoom).rotated(rotation-event.relative)
#	rotation -= event.relative
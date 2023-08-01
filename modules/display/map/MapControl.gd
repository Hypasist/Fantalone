class_name MapControl
extends Node

var zoomTween = null
var positionTween = null
var map_action_lockers = 0
func _on_Tween2D_all_completed(_object, _key):
	map_action_lockers = max(0, map_action_lockers - 1)
	
func _ready():
	zoomTween = CustomTween2.new()
	zoomTween.connect("tween_completed", self, "_on_Tween2D_all_completed")
	zoomTween.set_name("zoomTween")
	add_child(zoomTween)
	positionTween = CustomTween2.new()
	positionTween.connect("tween_completed", self, "_on_Tween2D_all_completed")
	positionTween.set_name("positionTween")
	add_child(positionTween)


var map = null
var screen_resolution = null
var mapview_center = null
func setup():
	map = mod.MapView
	screen_resolution = mod.Graphics.get_map_resolution()
	set_mapview_position(screen_resolution / 2.0, map.scale)
	
### --------------- ZOOM --------------- ###
const zoom_time = 0.25
const zoom_value_reference = 300

var diff_scale = Vector2(0,0)
var target_scale = Vector2(0,0)
func zoom(_center, zoom_value, isStep=false):
	if map_action_lockers: return
	
	# calculate scale
	var min_map_scale = mod.Graphics.get_min_map_scale()
	var max_map_scale = mod.Graphics.get_max_map_scale()
	diff_scale += Vector2(zoom_value, zoom_value) / zoom_value_reference
	diff_scale = Utils.clamp2(diff_scale, min_map_scale - Vector2(1,1), max_map_scale - Vector2(1,1))
	target_scale = Vector2(1,1) + diff_scale

	if isStep:
		# calculate position && run smoothly with locked tween
		var target_position = calculate_mapview_position(mapview_center, target_scale)
		mapview_center = position_to_center(screen_resolution, target_scale, target_position)
		map_action_lockers = 2
		zoomTween.initialize(map, "scale", map.scale, target_scale, zoom_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		zoomTween.start_normal(map.scale)
		positionTween.initialize(map, "position", map.position, target_position, zoom_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		positionTween.start_normal(map.position)
	else:
		# calculate position && run smoothly realtime
		map.set_scale(target_scale)
		set_mapview_position(mapview_center, target_scale)

### --------------- SCROLL --------------- ###
func scroll(scrollValue):
	if map_action_lockers: return
	var target_mapview_center = mapview_center - (scrollValue.rotated(map.rotation)/map.scale)
	set_mapview_position(target_mapview_center, map.scale)

func set_mapview_position(new_center, new_scale):
	map.position = calculate_mapview_position(new_center, new_scale)
	mapview_center = position_to_center(screen_resolution, new_scale, map.position)

func center_to_position(resolution, scale_, center):
	return (resolution/2.0 - center*scale_) 
func position_to_center(resolution, scale_, position_):
	return (resolution/2.0 - position_)/scale_

# from map-center (focus) to camera-topleft (position)
func calculate_mapview_position(new_center, new_scale):
	var minPositionValue = mod.Graphics.get_min_map_boundaries()
	var maxPositionValue = mod.Graphics.get_max_map_boundaries()
	# map is smaller than screen
	if screen_resolution.x / new_scale.x > (maxPositionValue.x - minPositionValue.x) || \
	   screen_resolution.y / new_scale.y > (maxPositionValue.y - minPositionValue.y):
		new_center = minPositionValue + (maxPositionValue - minPositionValue)/2.0
	else:
	# map is bigger than screen yet we need to respect map borders
		new_center = Utils.max2(minPositionValue + screen_resolution/new_scale/2.0, new_center)
		new_center = Utils.min2(maxPositionValue - screen_resolution/new_scale/2.0, new_center)
	return center_to_position(screen_resolution, new_scale, new_center)

### --- UTILS --- ###
func move_to_center():
	set_mapview_position(mod.Graphics.get_map_center(), map.scale)


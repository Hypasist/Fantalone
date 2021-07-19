extends Node2D
	
const utils = preload("res://utils/Utils.gd")


var zoomTween = null
var positionTween = null

var map_action_lockers = 0
func _on_Tween2D_all_completed(object, key):
	map_action_lockers = max(0, map_action_lockers - 1)
	
func _ready():
	zoomTween = CustomTween2.new()
	zoomTween.connect("tween_completed", self, "_on_Tween2D_all_completed")
	add_child(zoomTween)
	positionTween = CustomTween2.new()
	positionTween.connect("tween_completed", self, "_on_Tween2D_all_completed")
	add_child(positionTween)

var screen_resolution = null
var mapview_center = null 
func setup(_game_resolution):
	screen_resolution = _game_resolution
	scale = Vector2(1.4, 1.4)
	setWorldviewPosition(_game_resolution / 2.0, scale)

### --------------- ZOOM --------------- ###
const zoomTime = 0.25
const zoomValueReference = 300
const base_scale = Vector2(1,1)
const minScaleValue = Vector2(0.5, 0.5)
const maxScaleValue = Vector2(4, 4)
var diff_scale = Vector2(0,0)
var target_scale = Vector2(1,1)

func zoom(_center, zoomValue, isStep=false):
	if map_action_lockers: return
	
	# calculate scale
	var starting_scale = get_scale()
	diff_scale += Vector2(zoomValue,zoomValue) / zoomValueReference
	diff_scale = utils.clamp2(diff_scale, minScaleValue - base_scale, maxScaleValue - base_scale)
	target_scale = base_scale + diff_scale

	if isStep:
		# calculate position && run
		var target_position = calculateWorldviewPosition(mapview_center, target_scale)
		mapview_center = viewToWorld(screen_resolution / 2.0, target_scale, target_position)
		map_action_lockers = 2
		zoomTween.initialize(self, "scale", starting_scale, target_scale, zoomTime, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		zoomTween.start_normal(starting_scale)
		positionTween.initialize(self, "position", position, target_position, zoomTime, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		positionTween.start_normal(position)
	else:
		# calculate position && run
		set_scale(target_scale)
		setWorldviewPosition(mapview_center, target_scale)

### --------------- SCROLL --------------- ###
func scroll(scrollValue):
	if map_action_lockers: return
	
	var target_mapview_center = mapview_center - scrollValue.rotated(rotation)
	setWorldviewPosition(target_mapview_center, scale)
	
func setWorldviewPosition(new_center, new_scale):
	position = calculateWorldviewPosition(new_center, new_scale)
	mapview_center = viewToWorld(screen_resolution / 2.0, new_scale, position)

func worldToView(world_coords, _scale = scale, _position = position):
	return world_coords * _scale + _position
func viewToWorld(view_coords, _scale = scale, _position = position):
	return (view_coords - _position) / _scale

const minPositionValue = Vector2(-100, -100)
const maxPositionValue = Vector2(1124, 700)
# from map-center (focus) to camera-topleft (position)
func calculateWorldviewPosition(new_center, new_scale):
	# map is smaller than screen
	if screen_resolution > (maxPositionValue - minPositionValue) * new_scale:
		return (screen_resolution - (minPositionValue + maxPositionValue) * new_scale) / 2.0
	else:
	# map is bigger than screen yet we need to respect map borders
		new_center = utils.max2(minPositionValue + screen_resolution/new_scale/2.0, new_center)
		new_center = utils.min2(maxPositionValue - screen_resolution/new_scale/2.0, new_center)
		return screen_resolution/2.0 - new_center * new_scale
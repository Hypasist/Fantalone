extends Node2D

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
func setup():
	screen_resolution = Singletons.GameOptions.get_map_resolution()
	setWorldviewPosition(Singletons.GameOptions.get_game_resolution() / 2.0, scale)

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
	diff_scale = Utils.clamp2(diff_scale, minScaleValue - base_scale, maxScaleValue - base_scale)
	target_scale = base_scale + diff_scale

	if isStep:
		# calculate position && run
		var target_position = calculateWorldviewPosition(mapview_center, target_scale)
		mapview_center = positionToCenter(screen_resolution, target_scale, target_position)
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
	
	var target_mapview_center = mapview_center - (scrollValue.rotated(rotation)/scale)
	setWorldviewPosition(target_mapview_center, scale)
	
func setWorldviewPosition(new_center, new_scale):
	position = calculateWorldviewPosition(new_center, new_scale)
	mapview_center = positionToCenter(screen_resolution, new_scale, position)

func centerToPosition(resolution, scale_, center):
	return (resolution/2.0 - center*scale_) 
func positionToCenter(resolution, scale_ = scale, position_ = position):
	return (resolution/2.0 - position_)/scale_

# from map-center (focus) to camera-topleft (position)
func calculateWorldviewPosition(new_center, new_scale):
	var minPositionValue = Singletons.MatchOptions.get_min_map_boundaries()
	var maxPositionValue = Singletons.MatchOptions.get_max_map_boundaries()
	# map is smaller than screen
	if screen_resolution.x / new_scale.x > (maxPositionValue.x - minPositionValue.x)|| \
	   screen_resolution.y / new_scale.y > (maxPositionValue.y - minPositionValue.y):
		new_center = minPositionValue + (maxPositionValue - minPositionValue)/2.0
		print("A:", new_center)
	else:
	# map is bigger than screen yet we need to respect map borders
		new_center = Utils.max2(minPositionValue + screen_resolution/new_scale/2.0, new_center)
		new_center = Utils.min2(maxPositionValue - screen_resolution/new_scale/2.0, new_center)
	return centerToPosition(screen_resolution, new_scale, new_center)

class_name Graphics
extends Control

func setup_graphics():
	set_resolution(get_viewport().size)

### MAP RELATED
const tile_size = Vector2(128, 70)
func get_tilesize():
	return tile_size

const map_bounds_padding = 100
func get_map_bounds_padding():
	return Vector2(map_bounds_padding, map_bounds_padding)

var game_resolution = null
var map_resolution = null
func get_map_resolution():
	return map_resolution
func get_game_resolution():
	return game_resolution
# in the case of splitting screen into map and menu
var view_size_normalized = Vector2(0.85, 1)
func set_resolution(_resolution):
	Terminal.add_log(Debug.ALL, Debug.MATCH, "Match stopped.")
	game_resolution = _resolution
#	map_resolution = (Vector2(1,1) - view_size_normalized) * game_resolution
	map_resolution = view_size_normalized * game_resolution


##
var min_map_boundaries = Vector2(-100, -100)
var max_map_boundaries = Vector2(1124, 700)

func get_min_map_boundaries():
	return min_map_boundaries
func get_max_map_boundaries():
	return max_map_boundaries
func set_min_map_boundaries(value:Vector2):
	min_map_boundaries = value
func set_max_map_boundaries(value:Vector2):
	max_map_boundaries = value

##

const min_map_scale = Vector2(0.5, 0.5)
func get_min_map_scale():
	return min_map_scale

const max_map_scale = Vector2(4, 4)
func get_max_map_scale():
	return max_map_scale


func show_game():
	mod.Debug.show()
	mod.MapView.show()
	mod.Menu.hide()
	mod.Popups.hide()
	mod.GameUI.show()

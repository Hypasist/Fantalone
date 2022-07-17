extends Node

### VARIOUS CONSTANTS
const game_version = "0.1.0"

const MAX_PLAYER_NUM = 8
const colorList = [ Color.steelblue, Color.webmaroon, Color.coral, Color.darkgreen ]

### MAP RELATED
var tile_size = Vector2(128, 70)
func get_tilesize():
	return tile_size

const map_bounds_padding = 100
func get_map_bounds_padding():
	return Vector2(map_bounds_padding, map_bounds_padding)

var game_resolution = null
var map_resolution = null
# in the case of splitting screen into map and menu
var view_size_normalized = Vector2(0.85, 1)
func set_resolution(_resolution):
	game_resolution = _resolution
#	map_resolution = (Vector2(1,1) - view_size_normalized) * game_resolution
	map_resolution = view_size_normalized * game_resolution

const min_map_scale = Vector2(0.5, 0.5)
const max_map_scale = Vector2(4, 4)

### PLAYERS SETTINGS
var autofinish_turn = true

### PLAYER PRIVATE SETTINGS
var player_name = "My name"



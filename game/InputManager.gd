extends Node

export(int,"disabled","pinch") var zoom_gesture = 1
export(int,"disabled","twist") var rotation_gesture = 1
export(int,"disabled","single_drag","multi_drag") var movement_gesture = 1
export(int,"off","on") var debug_verbose = 0

func _ready():
	$UserActionManager.

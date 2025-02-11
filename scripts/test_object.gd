extends Node

func is_something_cool() -> bool:
	return true

func foo () -> String:
	return 'bar'

func _ready() -> void:
	var cube = StaticBody3D.new()
	add_child(cube)
	cube.transform.origin = Vector3(2.0, 4.2, 1.4)
	cube.get_transform()

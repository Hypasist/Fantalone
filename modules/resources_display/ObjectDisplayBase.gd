tool
class_name ObjectDisplayBase
extends Node2D

var logic = null
func assign_logic_scene(logic_scene):
	logic = logic_scene
	position = mod.Logic.hex_to_position(logic.get_hex().get_coords())

func execute_display_queue(_comp_object_, _comp_method_):
	pass

func set_select(value):
	if value:
		$Tile/Selected.show()
	else:
		$Tile/Selected.hide()

func _on_Object_mouse_entered():
	mod.UI.add_to_hoverlist(logic)
func _on_Object_mouse_exited():
	mod.UI.remove_from_hoverlist(logic)

class_name SpellBase

var image_path = ""
var name = "Default Spell Name"
var mana_cost = 0
var cooldown = 0
var selection_limit = 0

func setup():
	pass

func is_valid():
	pass

func new_selected(object):
	print(object.get_name_id())

func clear_selection():
	pass

func cast():
	pass

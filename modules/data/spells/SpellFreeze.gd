extends SpellBase

func setup():
	image_path = "res://art/spells/snowflake.png"
	name = "Freeze"
	mana_cost = 5
	cooldown = 4
	selection_limit = 1

var selected_tiles = []
func new_selected(object:ObjectLogicBase):
	if selected_tiles.has(object):
		object.set_select(false)
		selected_tiles.erase(object)
	else:
		object.set_select(true)
		selected_tiles.append(object)
	print(object.get_name_id())

func cast():
	pass

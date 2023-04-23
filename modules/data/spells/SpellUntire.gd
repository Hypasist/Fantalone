class_name SpellUntire
extends SpellBase

func setup():
	image_path = "res://art/spells/untire.png"
	name = "Untire"
	mana_cost = 0
	cooldown = 1
	selection_limit = 1

var selected_tiles = []
func new_selected(object:ObjectLogicBase):
	if object.get_hex().get_unit().has_tags([TagList.TIRED]):
		if not selected_tiles.has(object):
			clear_selection()
			object.set_select(true)
			selected_tiles.append(object)
			print(object.get_name_id())

func clear_selection():
	if not selected_tiles.empty():
		for tile in selected_tiles:
			tile.set_select(false)
		selected_tiles.clear()

func cast(Data):
	print("EffectTired casted!")
	for tile in selected_tiles:
		var unit = tile.get_hex().get_unit()
		unit.erase_effect_class(EffectTiredClass)

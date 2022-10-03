class_name UnitLogicBase
extends ObjectLogicBase

var _owner_id = null
var _power = 1

func _init(name_id, owner_id).(name_id):
	_owner_id = owner_id
	
func get_owner():
	return _owner_id

func move_to_hex(destination_hex):
	if hex: if hex.unit_logic == self: hex.unit_logic = null
	if destination_hex: destination_hex.unit_logic = self
	hex = destination_hex

func die():
	_marked_to_delete = true
	tag_list.append(TagList.CANNOT_BE_SELECTED)

func add_to_display_queue(display_command):
	if display:
		display.queue_command(display_command)

func pack():
	var pack = {}
	var packed_effects = []
	for effect in effect_list:
		packed_effects.append(effect.pack())
	pack["effects"] = packed_effects
	pack["unique_id"] = get_name_id()
	pack["resource"] = get_resource()
	pack["hex"] = get_hex().pack()
	pack["match_id"] = get_owner()
	return pack

# --- TAGS AND EFFECTS
var tag_list = []
func update_tag_list():
	tag_list = []
	for effect in effect_list:
		var tags = effect.tags
		for tag in tags:
			if not tag_list.has(tag):
				tag_list.append(tag)
func has_tags(tag_array:Array): # HAS AT LEAST ONE TAG
	for tag in tag_array:
		if tag_list.has(tag):
			return true
	return false

var effect_list = []
func add_effect(effect):
	effect_list.append(effect)
	update_tag_list()
func propagate_effects():
	var finished_effect_list = []
	for effect in effect_list:
		if effect.propagate():
			finished_effect_list.append(effect)
	erase_effect(finished_effect_list)
	update_tag_list()
func erase_effect_class(effect_class):
	var effect_to_finish_list = []
	for effect in effect_list:
		if effect is effect_class:
			effect_to_finish_list.append(effect)
	erase_effect(effect_to_finish_list)
func erase_effect(effect_to_finish_list):
	for effect in effect_to_finish_list:
		effect.stop_effect()
		effect_list.erase(effect)

class_name ErrorInfo

enum invalid { \
	no_reason, \
	out_of_map_boundaries, \
	unpassable_terrain, \
	pushing_own_units, \
	formation_too_weak, \
	tile_occupied, \
	not_your_turn, \
	need_at_least_one_move, \
	not_enough_action_points, \
	not_enough_mana_points, \
	invalid_turn_counter, \
	invalid_hash, \
	no_spell_target, \
	invalid_spell_target, \
}

static func get_invalid_string_by_enum(reason):
	return invalid.keys()[reason]
func get_invalid_string():
	return invalid.keys()[invalid_reason]

var invalid_reason = null
var valid = true

func _init(reason=null):
	if reason:
		invalid_move(reason)

func invalid_move(reason):
	valid = false
	invalid_reason = reason
func is_valid():
	return valid
func is_invalid():
	return not valid

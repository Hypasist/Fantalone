class_name EffectBase

const unlimited_duration = -1
var target = null
var caster = null
var duration_left = 0
var tags = []

func _init(_caster, _target, _duration):
	caster = _caster
	target = _target
	duration_left = _duration

func propagate():
	if duration_left == 1 or duration_left == 0:
		return true
	else:
		duration_left -= 1
		return false

func start_effect():
	target.add_effect(self)
func stop_effect():
	pass

func pack():
	var pack = {}
	pack["target"] = target.get_name_id()
	pack["caster"] = caster
	pack["duration"] = duration_left 
	pack["resource"] = get_resource()
	return pack

func get_resource():
	return null

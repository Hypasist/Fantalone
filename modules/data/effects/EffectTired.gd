class_name EffectTiredClass
extends EffectBase

func _init(_caster=null, _target=null, _turns_left=null).(_caster, _target, _turns_left):
	tags = [TagList.CANNOT_MOVE, TagList.TIRED]

func start_effect():
	Terminal.add_log(Debug.ALL, Debug.DISPLAY_CMD, "[%s] EffectTired" % [target.get_name_id()])
	.start_effect()
	DisCmdTireUnit.new(target)

func stop_effect():
	.stop_effect()
	DisCmdUntireUnit.new(target)

func get_resource():
	return Resources.EffectTired

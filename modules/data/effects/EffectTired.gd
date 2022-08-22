class_name EffectTired
extends EffectBase

func _init(_caster, _target, _turns_left).(_caster, _target, _turns_left):
	tags = [TagList.CANNOT_MOVE, TagList.TIRED]

func start_effect():
	Terminal.add_log(Debug.ALL, Debug.DISPLAY_CMD, "[%s] EffectTired" % [target.get_name_id()])
	.start_effect()
	DisCmdTireUnit.new(target)

func stop_effect():
	.stop_effect()
	DisCmdUntireUnit.new(target)

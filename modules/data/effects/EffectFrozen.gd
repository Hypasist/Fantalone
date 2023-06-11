class_name EffectFrozenClass
extends EffectBase

func _init(_caster=null, _target=null, _turns_left=null).(_caster, _target, _turns_left):
	tags = [TagList.CANNOT_MOVE, TagList.CANNOT_BE_PUSHED]
	
func start_effect():
	Terminal.add_log(Debug.ALL, Debug.DISPLAY_CMD, "[%s] EffectFrozen" % [target.get_name_id()])
	.start_effect()
	DisCmdFreezeUnit.new(target)

func stop_effect():
	.stop_effect()
	DisCmdUnfreezeUnit.new(target)

func get_resource():
	return Resources.EffectFrozen

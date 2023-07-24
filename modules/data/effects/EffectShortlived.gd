class_name EffectShortlivedClass
extends EffectBase

func _init(_caster=null, _target=null, _turns_left=null).(_caster, _target, _turns_left):
	#tags = [TagList.MARKED_TO_DELETE]
	pass
	
func start_effect():
	.start_effect()

func stop_effect():
	.stop_effect()
	target.die()
	DisCmdGetDrown.new(target)
	DisCmdHide.new(target)

func get_resource():
	return Resources.EffectShortlived

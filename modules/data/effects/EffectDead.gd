class_name EffectDeadClass
extends EffectBase

func _init(_caster=null, _target=null, _turns_left=null).(_caster, _target, _turns_left):
	tags = [TagList.MARKED_TO_DELETE]
	
func start_effect():
	pass
func stop_effect():
	pass

func get_resource():
	return Resources.EffectDead

class_name UnitAnimationControllerBase
extends Area2D

var bored_min_timer = 5
var bored_max_timer = 40

var animation_type = null
var comp_object = null
var comp_method = null

func setup_default_behaviour():
	start_animation(UnitAnimations.idle, UnitAnimations.type.perpetual)
	var time = bored_min_timer + randi() % (bored_max_timer - bored_min_timer)
	$Timer.start(time)

func start_animation(animation_name, animation_type_, \
					comp_object_ = null, comp_method_ = null):
	if $AnimatedSprite.get_sprite_frames().has_animation(animation_name):
		comp_object = comp_object_
		comp_method = comp_method_
		animation_type = animation_type_
		$Timer.stop()
		$AnimatedSprite.play(animation_name)

func _on_Timer_timeout():
	start_animation(UnitAnimations.bored, UnitAnimations.type.one_shot)

func _on_AnimatedSprite_animation_finished():
	if comp_object and comp_method:
		comp_object.call(comp_method)
		comp_object = null
		comp_method = null
	
	if animation_type == UnitAnimations.type.one_shot:
		setup_default_behaviour()
	elif animation_type == UnitAnimations.type.perpetual:
		pass

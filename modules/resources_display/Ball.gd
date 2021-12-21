class_name Ball
extends UnitDisplayBase

var color = Color.white

func _init():
	pass

func setup(logic):
	change_color(mod.Database.get_player_info(logic.get_owner()).color)
	.setup(logic)
	$NameLabel.set_text(unitLogic.get_name_id())
	$Unit.setup_default_behaviour()
	return self

func update_tired_state():
	if unitLogic.is_tired():
		$Tired.show()
	else:
		$Tired.hide()

func select():
	$Selected.show()
	$Unit.set_modulate(color.lightened(0.5))

func deselect():
	$Selected.hide()
	$Unit.set_modulate(color)

func change_color(color_):
	color = color_
	$Unit.set_modulate(color)

func start_animation(animation_name, animation_type, comp_object, comp_method):
	$Unit.start_animation(animation_name, animation_type, comp_object, comp_method)

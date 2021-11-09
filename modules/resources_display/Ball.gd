extends UnitDisplayBase

var color = Color.white

func _init():
	$Unit.set_modulate(color)

func setup(logic, hex_):
	.setup(logic, hex_)
	change_color(mod.Database.get_player_info(logic.owner_id).color)

func tire():
	$Tired.show()

func untire():
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
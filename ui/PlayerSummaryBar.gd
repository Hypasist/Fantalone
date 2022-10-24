extends Control

func update_bar(turn_, color_, name_, army_size_, mana_):
	update_turn(turn_)
	update_color(color_)
	update_name(name_)
	update_army_size(army_size_)
	update_mana(mana_)

func update_turn(turn_):
	$PlayerTurn.show() if turn_ else $PlayerTurn.hide()
func update_color(color_):
	$PlayerColor.set_frame_color(color_)
func update_name(name_):
	$PlayerName.set_text(name_)
func update_army_size(army_size_):
	$PlayerArmySize.set_text(str(army_size_))
func update_mana(mana_):
	$PlayerMana.set_text(str(mana_))

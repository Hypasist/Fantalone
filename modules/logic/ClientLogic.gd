extends Node

var selected_units = []
func deselect_all_units():
	for unit in selected_units:
		unit.deselect()
	selected_units.clear()

func select_unit(unit):
	selected_units.append(unit)
	unit.select()
	
func deselect_unit(unit):
	selected_units.erase(unit)
	unit.deselect()

func new_unit_selected(new_unit:UnitLogicBase):
	if mod.Database.get_current_turn_owner() != new_unit.get_owner(): return
	if new_unit.is_tired(): return

	# IF WASN'T SELECTED BEFORE -- SELECT AND CHECK
	if new_unit.is_selected() == false && not selected_units.has(new_unit):
		select_unit(new_unit)

		# CHECK IF NEW UNIT MATCHES A LINE
		# 	IF NOT THEN IT IS THE FIRST ONE OF NEW LINE
		if mod.Client.is_line_formation() == false:
			deselect_all_units()
			select_unit(new_unit)

	# IF WAS SELECTED BEFORE -- DESELECT AND CHECK
	elif new_unit.is_selected() == true && selected_units.has(new_unit):
		deselect_unit(new_unit)
		if mod.Client.is_line_formation() == false:
			deselect_all_units()
	else:
		Terminal.addLog("ERROR, new_item_status/selected_list mismatch")

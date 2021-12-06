extends Node

enum clients { ai, desktop, mobile }
var client_type = null
func identify_client():
	match OS.get_name():
		"Android":
			client_type = clients.mobile
		"Windows":
			client_type = clients.desktop
		_:
			Terminal.addLog("ERROR, cannot recognize OS!")


func get_client():
	return client_type
func has_graphic():
	return client_type is clients.desktop or client_type is client_type.mobile

func new_unit_selected(unit):
	$ClientLogic.new_unit_selected(unit)
	
func any_unit_selected():
	return $ClientLogic.selected_units.size() > 0

func is_line_formation():
	var unit_list = $ClientLogic.selected_units
	var formation = mod.Logic.recognize_line_unit(unit_list)
	return formation.is_line() if formation else false

func is_move_valid(direction):
	var unit_list = $ClientLogic.selected_units
	var movement = mod.Logic.recognize_movement_unit(unit_list, direction)
	return movement.is_valid() if movement else false

func make_move(direction):
	var unit_list = $ClientLogic.selected_units
	var movement = mod.Logic.make_move_unit(unit_list, direction)
	if not movement: return
	if movement.is_valid() == false:
		# TODO: TUTAJ INVALID REASON HANDLING
		pass

## INFORMING THE PLAYER ABOUT THE MOVE RESULTS:
## 	IF VALID:
##   	- the *destination* tile should have a color (OR ONLY BLUE??) of the incoming HEX
##		- if the *destination* tile is a lethal hex, present a skull
##	IF INVALID:
##		IF NO_REASON:
##			assert?
##		IF UNPASSABLE TERRAIN:
##			red cage on the unpassable terrain?, blue tile on any affected?
##		IF PUSHING OWN UNITS:
##			red cage on mentioned own unit, blue tile under any affected
##		IF FORMATION TOO WEAK:
##			RED CAGE on first invalid enemy hex, rest with blue tile under
##		IF TILE OCCUPIED:
##			red cage on tiles uccupied, blue tiles under own hexes
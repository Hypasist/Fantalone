extends Node

const PopupBase = preload("res://ui/PopupBase.tscn")
onready var hoverlist = $"../Worldview/Worldmap".hoverlist

var moveInfo = {}

var dragRelativeTreshold = 100
func _on_UserActionHandler_action_drag_active(position, relative):
	moveInfo.clear()
	if Singletons.Logic.any_unit_selected() == false:
		Singletons.UI.clear_direction()
	elif relative.length() < dragRelativeTreshold:
		Singletons.UI.set_no_direction_arrow(position)
	else:
		var direction = touchscreenScripts.angleVector2direction(relative)
		moveInfo = Singletons.Logic.considerMoving(direction)
		if moveInfo["isMoveValid"]:
			Singletons.UI.set_direction_arrow(position, direction)
		else:
			Singletons.UI.set_invalid_arrow(position)

func _on_UserActionHandler_action_drag_stopped():
	Singletons.UI.clear_direction()
	if moveInfo.empty() == false:
		Singletons.Logic.makeMove(moveInfo)
		Singletons.Logic.finishMove()
		Singletons.Logic.deselectAllUnits()
		moveInfo.clear()

func _on_UserActionHandler_action_longtap_active(position):
	Terminal.addLog(str("longtap",position))

func _on_UserActionHandler_action_longtap_stopped():
	Terminal.addLog(str("longtap stop"))


func _on_UserActionHandler_action_shorttap(position):
	for hovered_object in hoverlist:
		if(hovered_object.is_in_group("Actors")):
			Singletons.Logic.new_selected(hovered_object)
			return

func _on_UserActionHandler_action_cancel():
	pass # Replace with function body.
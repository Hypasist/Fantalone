extends Node

const PopupBase = preload("res://ui/PopupBase.tscn")
onready var eventlog = $"../UI/EventLog"
onready var hoverlist = $"../Worldview/Worldmap".hoverlist
onready var gamelogic = $"../GameLogic"
onready var UI = $"../UI"

var perspectiveRatioMod = Vector2(1.0, 0.5)
var dragRelativeTreshold = 100
func _on_UserActionManager_action_drag_active(position, relative):
	if gamelogic.any_selected():
		var plainRelative = relative # / perspectiveRatioMod
		if plainRelative.length() < dragRelativeTreshold:
			UI.set_no_direction(position)
		else:
			var angle = fmod(plainRelative.angle() + (17.0/6.0 * PI), 2*PI)
			var direction = int(angle / (PI/3.0))
			UI.set_direction(position, direction)

func _on_UserActionManager_action_drag_stopped():
	UI.clear_direction()


func _on_UserActionManager_action_longtap_active(position):
	eventlog.addLog(str("longtap",position))


func _on_UserActionManager_action_longtap_stopped():
	eventlog.addLog(str("longtap stop"))


func _on_UserActionManager_action_shorttap(position):
	for hovered_object in hoverlist:
		if(hovered_object.is_in_group("Actors")):
			gamelogic.new_selected(hovered_object)
			return

func _on_UserActionManager_action_cancel():
	pass # Replace with function body.

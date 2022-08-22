class_name SpellcastUI
extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func targetting():
	pass

func _on_AcceptSpellButton_pressed():
	mod.MatchUI.spell_casted()

func _on_CancelSpellButton_pressed():
	mod.MatchUI.spell_deselected()

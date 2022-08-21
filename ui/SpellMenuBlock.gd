class_name SpellMenuBlock
extends Button

func setup(spell_info):
	$VBoxContainer/HBoxContainer/ManaCounter.set_text("%d" % spell_info.mana_cost)
	$VBoxContainer/HBoxContainer/NameLabel.set_text(spell_info.name)
	$VBoxContainer/HBoxContainer/CooldownCounter.set_text("%d" % spell_info.cooldown)
	$VBoxContainer/TextureRect.texture = load(spell_info.image_path)

signal spell_selected(object)
func _on_SpellMenuBlock_pressed():
	emit_signal("spell_selected", self)

func _on_HelpButton_pressed():
	print("_on_HelpButton_pressed")

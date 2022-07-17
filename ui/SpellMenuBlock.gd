class_name SpellMenuBlock
extends Button

func setup(spell_script):
	var spell1 = load(spell_script)
	var spell_info = spell1.new()
	spell_info.setup()
	$VBoxContainer/HBoxContainer/ManaCounter.set_text("%d" % spell_info.mana_cost)
	$VBoxContainer/HBoxContainer/NameLabel.set_text(spell_info.name)
	$VBoxContainer/HBoxContainer/CooldownCounter.set_text("%d" % spell_info.cooldown)
	
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(spell_info.image_path)
	texture.create_from_image(image)
	$VBoxContainer/TextureRect.texture = texture
	

func _on_SpellMenuBlock_pressed():
	print("_on_SpellMenuBlock_pressed")

func _on_HelpButton_pressed():
	print("_on_HelpButton_pressed")

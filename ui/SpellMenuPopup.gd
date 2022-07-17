class_name SpellMenuPopup
extends PopupBase

var SpellBlock = null
var spell_block_list = []

func _ready():
	_default_size = Vector2(.6,1)

func setup(size:Vector2=Vector2(0,0)):
	SpellBlock = load("res://ui/SpellMenuBlock.tscn")
	.setup(size)
	var spell_list = mod.SpellData.get_spell_list()
	for spell in spell_list:
		var spell_block = SpellBlock.instance()
		spell_block.setup(spell)
		$Box/VBoxContainer/ScrollContainer/GridContainer.add_child(spell_block)
		spell_block_list.append(spell_block)

func _on_CancelButton_pressed():
	mod.PopupUI.pop_popup(self)

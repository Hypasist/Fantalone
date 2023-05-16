class_name SpellMenuPopup
extends PopupBase

var SpellBlock = preload("res://ui/SpellMenuBlock.tscn")
var spell_block_list = {}

func _ready():
	_default_size = Vector2(.6,1)

func setup(size:Vector2=Vector2(0,0)):
	.setup(size)
	mod.GameUI.set_UI_action(GameUI.UI_ACTION_NONE)
	var spell_list = LogCmd.get_spell_list()
	for spell_class in spell_list:
		var spell_block = SpellBlock.instance()
		var spell_info = spell_class.new({"data":mod.ClientData})
		spell_block.setup(spell_info)
		$Box/VBoxContainer/ScrollContainer/GridContainer.add_child(spell_block)
		spell_block.connect("spell_selected", self, "_on_SpellButton_pressed")
		spell_block_list[spell_block] = (spell_info)

func _on_SpellButton_pressed(object):
	mod.GameUI.spell_selected(spell_block_list[object])
	mod.Popups.pop_popup(self)

func _on_CancelButton_pressed():
	mod.GameUI.set_UI_action(GameUI.UI_ACTION_MOVE)
	mod.Popups.pop_popup(self)

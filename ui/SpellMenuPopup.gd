class_name SpellMenuPopup
extends PopupBase

var SpellBlock = null
var spell_block_list = {}

func _ready():
	_default_size = Vector2(.6,1)

func setup(size:Vector2=Vector2(0,0)):
	SpellBlock = load("res://ui/SpellMenuBlock.tscn")
	.setup(size)
	var spell_list = mod.SpellList.get_spell_list()
	for spell_path in spell_list:
		var spell_info_scene = load(spell_path)
		var spell_block = SpellBlock.instance()
		var spell_info = spell_info_scene.new()
		spell_info.setup()
		spell_block.setup(spell_info)
		$Box/VBoxContainer/ScrollContainer/GridContainer.add_child(spell_block)
		spell_block.connect("spell_selected", self, "_on_SpellButton_pressed")
		spell_block_list[spell_block] = (spell_info)

func _on_SpellButton_pressed(object):
	if spell_block_list.has(object):
		print("YAY  ", object, "  ", spell_block_list[object])
	mod.MatchUI.spell_selected(spell_block_list[object])
	mod.Popups.pop_popup(self)

func _on_CancelButton_pressed():
	mod.Popups.pop_popup(self)

extends NinePatchRect

const internal_top_padding = 5
const internal_leftright_padding = 5
const internal_bot_padding = 5

func _ready():
	var size = get_size()
	$MarginContainer.set("custom_constants/margin_top", get_patch_margin(MARGIN_TOP) + internal_top_padding)
	$MarginContainer.set("custom_constants/margin_left", get_patch_margin(MARGIN_LEFT) + internal_leftright_padding)
	$MarginContainer.set("custom_constants/margin_bottom", size.y - get_patch_margin(MARGIN_BOTTOM) - internal_bot_padding)
	$MarginContainer.set("custom_constants/margin_right", size.x - get_patch_margin(MARGIN_RIGHT) - internal_leftright_padding)

func set_text(_text):
	$MarginContainer/RichTextLabel.set_text(_text)
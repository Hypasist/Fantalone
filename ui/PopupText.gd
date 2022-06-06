class_name PopupText
extends PopupBase

func setup(size:Vector2=Vector2(0,0)):
	.setup(size)
	
func setup_text(text:String=""):
	$Box/RichTextLabel.set_text(text)

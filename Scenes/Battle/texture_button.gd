@tool
extends TextureButton

@export var text = "Text" # text to be displayed in the button

func _ready():
	setup_text()
	
	# this function is needed to grab the focus from the keyboard
	set_focus_mode(2) 

func _process(delta):
	if has_focus():
		SignalManager.btn_pos.emit(global_position.x - 4, global_position.y + 6)

func setup_text():
	# changes the text button
	$Label.text = text

func show_text():
	return str($Label.text)

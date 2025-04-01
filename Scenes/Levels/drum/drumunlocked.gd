extends Node2D

@onready var noise = {}
@onready var instruments =  ["bass","snare","hihat","cymbal","floortom","medtom","hightom"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for par in instruments:
		noise[par] = get_node("./sounds/"+par)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for part in instruments:
		if Input.is_action_just_pressed(part):
			noise[part].play()
			SignalManager.emit_signal("send_played",part,"")
	

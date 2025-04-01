extends Control

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("select"):
		load_game()

func load_game():
	get_tree().change_scene_to_file("res://Scenes/Levels/world.tscn")

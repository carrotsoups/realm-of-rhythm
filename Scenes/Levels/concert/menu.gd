extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("./selected").text = str(name)[4]
	var info = get_info()
	get_node("./"+"min level").text = "Lvl. > " + str(info["min level"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func get_info():
	var dict = {}
	dict["min level"] = 5
	return dict

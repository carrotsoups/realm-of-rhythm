extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.connect("concertscore",display_scores)
	
func display_scores(score:Dictionary):
	get_node("./piano").text = str(score["piano"][0])+"/"+str(score["piano"][1])
	get_node("./overall").text = str(score["piano"][0]+score["drums"][0])+"/"+str(score["piano"][1]+score["drums"][1])
	get_node("./drum").text = str(score["drums"][0])+"/"+str(score["drums"][1])
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

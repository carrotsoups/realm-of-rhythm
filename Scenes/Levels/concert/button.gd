extends Node2D

@onready var isRecording = false
@onready var state = "notrecording"
@onready var inrange = false
@onready var space:Area2D = get_node("./Area2D")
@onready var buttRecord = get_node("./button/recording")
@onready var buttNotRecord = get_node("./button/notrecording")

func _ready():
	get_node("./e").hide()
	buttNotRecord.show()
	buttRecord.hide()
	SignalManager.connect("recordingstatechanged",change_butts)

func change_butts(s:String):
	if s == "recording":
		buttNotRecord.hide()
		buttRecord.show()
		name = "recording"
	else:
		buttNotRecord.show()
		buttRecord.hide()
		name = "notrecording"
		

func _process(delta: float) -> void:
	if inrange:
		if Input.is_action_just_released("select"):
			SignalManager.emit_signal("button_clicked")


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		get_node("./e").show()
		inrange = true


func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	get_node("./e").hide()
	inrange = false

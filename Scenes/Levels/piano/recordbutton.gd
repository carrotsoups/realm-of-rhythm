extends Area2D

@onready var isRecording = false
@onready var allowed = false
@onready var recording = []
@onready var buttRecord = get_node("./button/recording")
@onready var buttNotRecord = get_node("./button/notrecording")

func _ready():
	get_node("./e").hide()
	buttNotRecord.show()
	buttRecord.hide()

func _process(delta: float) -> void:
	if allowed and Input.is_action_just_released("select"):
		if isRecording:
			isRecording = false
			buttNotRecord.show()
			buttRecord.hide()
			SignalManager.recordednotes.emit(recording)
			name = "notrecording"

		else:
			isRecording = true
			recording = []
			buttNotRecord.hide()
			buttRecord.show()
			name = "recording"
		SignalManager.emit_signal("recordingstatechanged",name)


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		get_node("./e").show()
		allowed = true


func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		get_node("./e").hide()
		allowed = false

func _on_f_3_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		recording.append("f3")


func _on_g_3_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		recording.append("g3")


func _on_a_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		recording.append("a4")


func _on_b_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		recording.append("b4")


func _on_c_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		recording.append("c4")


func _on_d_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		recording.append("d4")


func _on_e_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		recording.append("e4")


func _on_f_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		recording.append("f4")


func _on_g_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		recording.append("g4")


func _on_a_5_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		recording.append("a5")

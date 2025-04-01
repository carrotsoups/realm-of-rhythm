extends Node2D

@onready var pathlight = "light_up/"
@onready var pathanim = "tile_animations/"
@onready var pathplay = "Notes/"
@onready var notes = {
		"f3": {
			"light":get_node(pathlight+ "f3"),
			"anim":get_node(pathanim+ "f3"),
			"play":get_node(pathplay+ "f3"),
		},
		"g3": {
			"light":get_node(pathlight+ "g3"),
			"anim":get_node(pathanim+ "g3"),
			"play":get_node(pathplay+ "g3"),
		},
		"a4": {
			"light":get_node(pathlight+ "a4"),
			"anim":get_node(pathanim+ "a4"),
			"play":get_node(pathplay+ "a4"),
		},
		"b4": {
			"light":get_node(pathlight+ "b4"),
			"anim":get_node(pathanim+ "b4"),
			"play":get_node(pathplay+ "b4"),
		},
		"c4": {
			"light":get_node(pathlight+ "c4"),
			"anim":get_node(pathanim+ "c4"),
			"play":get_node(pathplay+ "c4"),
		},
		"d4": {
			"light":get_node(pathlight+ "d4"),
			"anim":get_node(pathanim+ "d4"),
			"play":get_node(pathplay+ "d4"),
		},
		"e4": {
			"light":get_node(pathlight+ "e4"),
			"anim":get_node(pathanim+ "e4"),
			"play":get_node(pathplay+ "e4"),
		},
		"f4": {
			"light":get_node(pathlight+ "f4"),
			"anim":get_node(pathanim+ "f4"),
			"play":get_node(pathplay+ "f4"),
		},
		"g4": {
			"light":get_node(pathlight+ "g4"),
			"anim":get_node(pathanim+ "g4"),
			"play":get_node(pathplay+ "g4"),
		},
		"a5": {
			"light":get_node(pathlight+ "a5"),
			"anim":get_node(pathanim+ "a5"),
			"play":get_node(pathplay+ "a5"),
		}
	}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func play_note(note:String):
	notes[note]["play"].play()
	notes[note]["anim"].play()
	
func _on_c_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("c4")
		SignalManager.emit_signal("send_played","piano","c4")


func _on_a_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("a4")
		SignalManager.emit_signal("send_played","piano","a4")


func _on_b_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("b4")
		SignalManager.emit_signal("send_played","piano","b4")


func _on_d_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("d4")
		SignalManager.emit_signal("send_played","piano","d4")


func _on_e_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("e4")
		SignalManager.emit_signal("send_played","piano","e4")


func _on_f_3_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("f3")
		SignalManager.emit_signal("send_played","piano","f3")


func _on_g_3_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("g3")
		SignalManager.emit_signal("send_played","piano","g3")


func _on_f_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("f4")
		SignalManager.emit_signal("send_played","piano","f4")


func _on_g_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("g4")
		SignalManager.emit_signal("send_played","piano","g4")

func _on_a_5_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("a5")
		SignalManager.emit_signal("send_played","piano","a5")

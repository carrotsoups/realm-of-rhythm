extends Area2D


@onready var pathlight = "./light_up/"
@onready var pathanim = "./tile_animations/"
@onready var pathplay = "./Notes/"
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


@onready var player = get_node("../Player")
@onready var songseq = [["e4",1]]
@onready var hotxbuns = [
	["e4",1],
	["d4",1],
	["c4",1],
	
	["e4",1],
	["d4",1],
	["c4",1],
	
	["c4",0.5],
	["c4",0.5],
	["c4",0.5],
	["c4",0.5],
	
	["d4",0.5],
	["d4",0.5],
	["d4",0.5],
	["d4",0.5],
	
	["e4",1],
	["d4",1],
	["c4",1],
]



func _ready():
	get_node("./e").hide()

		
func _process(delta):
	if overlaps_body(player):
		if Input.is_action_just_released("select"):
			play_tune(songseq)
			print("Emitting song signal with:", songseq)
			SignalManager.song.emit(songseq)
			print("Signal emitted")
			
			
func play_note(note:String, length:float) -> void:
	notes[note]["light"].play()
	notes[note]["play"].play()
	await wait(length)
func play_tune(song:Array):
	for playthisnote in song:
		await play_note(playthisnote[0],playthisnote[1])
	

	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		get_node("./e").show()
		


func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		get_node("./e").hide()

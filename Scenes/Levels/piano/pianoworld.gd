extends Node2D

@onready var pathlight = ".//light_up/"
@onready var pathanim = "./Pianoplayable/tile_animations/"
@onready var pathplay = "./Pianoplayable/Notes/"
@onready var isInfoOpen = false
@onready var infoRect:Node2D = get_node("./Info")
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

@onready var wantedsequence = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	infoRect.hide()
	var connected = SignalManager.connect("recordednotes", check_pass)
	print("Connected to recordednotes:", connected)

	await SignalManager.connect("song", sequence)
	SignalManager.connect("drumworldunlocked",unlock_drum)
	#print("Connected to song:", connected)
	
func extract_notes(so):
	var seq = []
	for n in so:
		seq.append(n[0])
	print(seq)
	return seq
func sequence(s):
	print("sdgjnsdfd")
	wantedsequence = extract_notes(s)
	print(wantedsequence)
func check_pass(recording):
	print(wantedsequence == recording)
	print(wantedsequence)
	print(recording)
	if wantedsequence == recording:
		print("correct patter!")
		GameManager.instrumentLevels["piano"] += 1
	else:
		print("incorrect tune :()")
	return wantedsequence == recording


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_menu"):
		isInfoOpen = not isInfoOpen
		if isInfoOpen:
			infoRect.show()
		else:
			infoRect.hide()

func unlock_drum():
	var e:AnimatedSprite2D = get_node("./unlocking")
	await get_tree().create_timer(1).timeout
	e.show()
	await get_tree().create_timer(2).timeout
	e.play()
	print("unlocked drum")
	await get_tree().create_timer(3).timeout
	e.hide()
	get_node("./drum").show()
	await get_tree().create_timer(3).timeout
	get_node("./drum").hide()
	GameManager.playerInfo["unlocked"]["drumset"][0] = true



func _on_returntoworld_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.world = "Levels/world.tscn"
		GameManager.change_scene(GameManager.world)

func play_note(note:String):
	notes[note]["play"].play()
	notes[note]["anim"].play()
	
func _on_c_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("c4")


func _on_a_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("a4")


func _on_b_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("b4")


func _on_d_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("d4")


func _on_e_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("e4")


func _on_f_3_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("f3")


func _on_g_3_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("g3")


func _on_f_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("f4")


func _on_g_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("g4")

func _on_a_5_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		play_note("a5")

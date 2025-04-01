extends Node2D

@onready var posdrum = 0
@onready var pospiano = 0
@onready var pastpiano = -200
@onready var pastdrum = -200
@onready var recordbutt = get_node("./Camera2D/recordbutton")
@onready var doneRecording = false
@onready var camera:Camera2D = get_node("./Camera2D")
@onready var submittedSong = {"piano":[],"drum":[]}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.played = {"piano":[],"drum":[]}
	SignalManager.connect("send_played",add_to_played)
	SignalManager.connect("button_clicked",next_action)
	
func next_action():
	if recordbutt.name == "recording":
		"""GameManager.played = {"piano":[],"drum":[]}
		posdrum = 0
		pospiano = 0
		pastpiano = -200
		pastdrum = -200
		camera.position.x = 0
		get_node("./").remove_child(get_node("notesplayed"))
		var notesplayedd:Node2D = Node2D.new()
		notesplayedd.name = "notesplayed"
		get_node("./").add_child(notesplayedd)
		SignalManager.emit_signal("recordingstatechanged","notrecording")"""
		GameManager.world = "Levels/world.tscn"
		GameManager.change_scene(GameManager.world)
	else:
		submittedSong = GameManager.played
		GameManager.played = {"piano":[],"drum":[]}
		print(submittedSong)
		
	
	
func add_to_played(instrument:String, note:String):
	print(instrument,note)
	if recordbutt.name != "recording":
		return
	var image:Sprite2D = Sprite2D.new()
	if instrument == "cymbal":
		image.texture = load("res://Assets/Sprites/drumworld/quarter.png")
	elif instrument == "hihat":
		image.texture = load("res://Assets/Sprites/drumworld/quarterhihat.png")
	else:
		image.texture = load("res://Assets/Sprites/drumworld/quarterreg.png")
		
	if instrument != "piano":
		var positioning = {
			"hihat":-90,
			"cymbal":-85,
			"snare":-80,
			"hightom":-75,
			"medtom":-70,
			"floortom":-65,
			"bass":-60
		}
		image.position = Vector2(posdrum+pastdrum,positioning[instrument])
		posdrum += 20
	else:
		var positioning = {
			"f3":-150,
			"g3":-145,
			"a4":-140,
			"b4":-135,
			"c4":-130,
			"d4":-125,
			"e4":-120,
			"f4":-115,
			"g4":-110,
			"a5":-105,
		}
		image.position = Vector2(pospiano+pastpiano,positioning[note])
		pospiano += 20
	get_node("notesplayed").add_child(image)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pospiano >= 150 or posdrum >= 150:
		pastpiano += pospiano
		pastdrum += pastdrum
		posdrum = 0
		pospiano = 0
		camera.position.x += 150
		
	if recordbutt.name == "recording":
		if Input.is_action_just_released("drumrest"):
			var image:Sprite2D = Sprite2D.new()
			image.texture = load("res://Assets/Sprites/drumworld/rest.png")
			image.position = Vector2(posdrum+pastdrum,-75)
			posdrum += 20
			get_node("notesplayed").add_child(image)
			GameManager.played["drum"].append("rest")
		elif Input.is_action_just_released("pianorest"):
			var image:Sprite2D = Sprite2D.new()
			image.texture = load("res://Assets/Sprites/drumworld/rest.png")
			image.position = Vector2(pospiano+pastpiano,-125)
			pospiano += 20
			get_node("notesplayed").add_child(image)
			GameManager.played["piano"].append("rest")

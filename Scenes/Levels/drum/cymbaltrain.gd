extends Node2D
@onready var noise = get_node("./cymbal")
@onready var staffmap = get_node("./TileMap/notes")
@onready var loc = "res://Assets/Sprites/drumworld/"
@onready var tilemap = {
	"rest":[Vector2i(2,0),load(loc+"rest.png")],
	"quarter":[Vector2i(1,0),load(loc+"quarter.png")],
	"bar":[Vector2i(0,0),load(loc+"bar.png")],
	
}
@onready var songDone = false
@onready var score = 0
@onready var rigid_body = get_node("Path2D/PathFollow2D/Camera2D/RigidBody2D")
@onready var good:ColorRect = get_node("Path2D/PathFollow2D/Camera2D/good")
@onready var bad:ColorRect = get_node("Path2D/PathFollow2D/Camera2D/bad")
@onready var initial_position = rigid_body.position
@onready var curr = 0
@onready var currNote = "rest"
@onready var song = []
@onready var collisions = []
@onready var notePlayed = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.connect("cymbalsongdone",songdone)
	var ssong = generate_song(4,4,["rest","quarter"])
	#var ssong = generate_song(4,4,["quarter"])
	#var ssong = generate_song(4,4,["rest"])
	SignalManager.emit_signal("song_length",4*4*55)
	var start = 0
	for bar in ssong:
		for note in bar:
			song.append(note)
		song.append("bar")
	
	for bar in range(len(song)):
		if song[bar] != "bar":
			draw_note(song[bar],Vector2i(start,[-75,-100].pick_random()),start, bar)
		else:
			draw_bar("bar",Vector2i(start,-97),start,bar)
		start += 1
	
	var end:StaticBody2D = StaticBody2D.new()
	var icon: Sprite2D = Sprite2D.new();
	icon.position.x =  ((start-1) * 85)+5;
	icon.position.y = -97;
	icon.scale = Vector2(2,2)
	icon.centered = false;
	icon.set_texture(tilemap["bar"][1])
	end.add_child(icon)
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = icon.texture.get_size()*icon.scale
	collision_shape.shape = shape
	collision_shape.position.x = ((start-1) * 85)+5
	collision_shape.position.y = -97
	end.add_child(collision_shape)
	end.name = "endofsong"
	get_node(".").add_child(end)

	print(song)
	
	await countdown(3)
	# Lock rotation (so it won't rotate)
	

func countdown(seconds:int):
	var t = Timer.new()
	t.wait_time = seconds
	t.start()
	await t.timeout
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("cymbal"):
		notePlayed += 1
		noise.play()
		if currNote == null:
			good.hide()
			bad.show()
			print("no note")
		elif notePlayed > 1 and currNote == "quarter":
			good.hide()
			bad.show()
			print("too many")
		elif currNote == "rest":
			good.hide()
			bad.show()
			print("resting")
	
		
	

func songdone():
	if score >= 0.6*16:
		GameManager.playerInfo["unlocked"]["drumset"][1]["cymbal"] = true
	GameManager.world = "Levels/drum/drumworld.tscn"
	GameManager.change_scene(GameManager.world)
	

func generate_song(beatsperbar:int,totalbars:int,possiblenotes:Array)->Array:
	var notes = []
	for x in range(totalbars):
		var bar = []
		for y in range(beatsperbar):
			bar.append(possiblenotes.pick_random())
		notes.append(bar)
	return notes
	
func draw_bar(type:String,location:Vector2i,notepos:int,n:int):
	var icon : Sprite2D = Sprite2D.new();
	icon.position.x = notepos * 85;
	icon.position.y = location.y;
	icon.scale = Vector2(2,2)
	icon.centered = false;
	icon.set_texture(tilemap[type][1])
	icon.name = "bar"+str(n)
	get_node("./notes/").add_child(icon);

func draw_note(type:String,location:Vector2i,notepos:int, n:int):
	var icon : Sprite2D = Sprite2D.new();
	icon.position.x = notepos * 85;
	icon.position.y = location.y;
	icon.scale = Vector2(2,2)
	icon.centered = false;
	icon.set_texture(tilemap[type][1])
	var e = StaticBody2D.new()
	
	var collision_shape = CollisionShape2D.new()
	var texture = icon.texture
	var texture_size = texture.get_size() * icon.scale
	var shape = RectangleShape2D.new()
	shape.size = texture_size
	collision_shape.shape = shape
	collision_shape.position = icon.position
	
	e.add_child(icon)
	e.add_child(collision_shape)
	e.name = type+str(n)
	collisions.append(e)

	get_node("./notes/").add_child(e);
	#staffmap.set_cell(location,0,tilemap[type])



func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if "quarter" in body.name:
		currNote = "quarter"
	elif "rest" in body.name:
		currNote = "rest"
	print(currNote)
	#print(body.name)

func _on_rigid_body_2d_body_exited(body: Node) -> void:
	if str(body.name) == "endofsong":
		SignalManager.emit_signal("cymbalsongdone")
	elif currNote == "quarter":
		if  notePlayed != 1:
			good.hide()
			bad.show()
			print("no hit")
		else:
			good.show()
			bad.hide()
			collisions[0].hide()
			print("yes hit")
			score+=1
		collisions.remove_at(0)
			
	elif currNote == "rest":
		if notePlayed != 0:
			good.hide()
			bad.show()
			print("no rest")
		else:
			good.show()
			bad.hide()
			collisions[0].hide()
			print("yes rest")
			score += 1
	
		collisions.remove_at(0)
	notePlayed = 0
	currNote = null
		

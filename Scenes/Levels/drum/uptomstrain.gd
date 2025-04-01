extends Node2D
@onready var highnoise = get_node("./hightom")
@onready var mednoise = get_node("./medtom")
@onready var staffmap = get_node("./TileMap/notes")
@onready var loc = "res://Assets/Sprites/drumworld/"
@onready var tilemap = {
	"rest":[Vector2i(2,0),load(loc+"rest.png")],
	"quarter":[Vector2i(1,0),load(loc+"quarter.png")],
	"bar":[Vector2i(0,0),load(loc+"bar.png")],
	
}
@onready var t = Timer.new()
@onready var songDone = false
@onready var score = 0
@onready var highgood:ColorRect = get_node("Path2D/PathFollow2D/Camera2D/hightom/good")
@onready var highbad:ColorRect = get_node("Path2D/PathFollow2D/Camera2D/hightom/bad")
@onready var medgood:ColorRect = get_node("Path2D/PathFollow2D/Camera2D/medtom/good")
@onready var medbad:ColorRect = get_node("Path2D/PathFollow2D/Camera2D/medtom/bad")
@onready var highcurrNote = "rest"
@onready var medcurrNote = "rest"
@onready var highsong = []
@onready var medsong = []
@onready var highcollisions = []
@onready var medcollisions = []
@onready var highnotePlayed = 0
@onready var mednotePlayed = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node(".").add_child(t)
	SignalManager.connect("uptomssongdone",songdone)
	var highssong = generate_song(4,4,["rest","quarter"])
	var medssong = generate_song(4,4,["rest","quarter"])
	#var ssong = generate_song(4,4,["quarter"])
	#var ssong = generate_song(4,4,["rest"])
	SignalManager.emit_signal("song_length",4*4*55)
	var start = 0
	for bar in highssong:
		for note in bar:
			highsong.append(note)
		highsong.append("bar")
	
	for bar in range(len(highsong)):
		if highsong[bar] != "bar":
			draw_note(highsong[bar],Vector2i(start,[-75,-100].pick_random()),start, bar,"high")
		else:
			draw_bar("bar",Vector2i(start,-97),start,bar,"high")
		start += 1
		
	start = 0
	for bar in medssong:
		for note in bar:
			medsong.append(note)
		medsong.append("bar")
	
	for bar in range(len(medsong)):
		if medsong[bar] != "bar":
			draw_note(medsong[bar],Vector2i(start,[(-75+97),-3].pick_random()),start, bar,"med")
		else:
			draw_bar("bar",Vector2i(start,0),start,bar,"med")
			
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

	print(highsong,medsong)
	
	await countdown(3)
	# Lock rotation (so it won't rotate)
	

func countdown(seconds:int):
	t.wait_time = seconds
	t.start()
	await t.timeout
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("hightom"):
		highnotePlayed += 1
		highnoise.play()
		if highcurrNote == null:
			highgood.hide()
			highbad.show()
			print("no note")
		elif highnotePlayed > 1 and highcurrNote == "quarter":
			highgood.hide()
			highbad.show()
			print("too many")
		elif highcurrNote == "rest":
			highgood.hide()
			highbad.show()
			print("resting")
			
	if Input.is_action_just_released("medtom"):
		mednotePlayed += 1
		mednoise.play()
		if medcurrNote == null:
			medgood.hide()
			medbad.show()
			print("no note")
		elif mednotePlayed > 1 and medcurrNote == "quarter":
			medgood.hide()
			medbad.show()
			print("too many")
		elif medcurrNote == "rest":
			medgood.hide()
			medbad.show()
			print("resting")
	
		
	

func songdone():
	if score >= 0.6*16:
		GameManager.playerInfo["unlocked"]["drumset"][1]["uptoms"] = true
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
	
func draw_bar(type:String,location:Vector2i,notepos:int,n:int,highormed:String):
	var icon : Sprite2D = Sprite2D.new();
	icon.position.x = notepos * 85;
	icon.position.y = location.y;
	icon.scale = Vector2(2,2)
	icon.centered = false;
	icon.set_texture(tilemap[type][1])
	icon.name = "bar"+str(n)
	if highormed == "high":
		get_node("./highnotes/").add_child(icon);
	elif highormed == "med":
		get_node("./mednotes/").add_child(icon);

func draw_note(type:String,location:Vector2i,notepos:int, n:int,highormed:String):
	var icon : Sprite2D = Sprite2D.new();
	icon.position.x = notepos * 85;
	icon.position.y = location.y;
	icon.scale = Vector2(2,2)
	icon.centered = false;
	icon.texture = load("res://Assets/Sprites/drumworld/quarterreg.png")
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
	if highormed == "high":
		highcollisions.append(e)
		get_node("./mednotes/").add_child(e);
	elif highormed == "med":
		medcollisions.append(e)
		get_node("./mednotes/").add_child(e);
	#staffmap.set_cell(location,0,tilemap[type])

		


func _on_highrigid_body_entered(body: Node) -> void:
	if "quarter" in body.name:
		highcurrNote = "quarter"
	elif "rest" in body.name:
		highcurrNote = "rest"
	print(highcurrNote)
	#print(body.name)


func _on_highrigid_body_exited(body: Node) -> void:
	if str(body.name) == "endofsong":
		SignalManager.emit_signal("uptomssongdone")
	elif highcurrNote == "quarter":
		if  highnotePlayed != 1:
			highgood.hide()
			highbad.show()
			print("no hit")
		else:
			highgood.show()
			highbad.hide()
			highcollisions[0].hide()
			print("yes hit")
			score+=1
		highcollisions.remove_at(0)
			
	elif highcurrNote == "rest":
		if highnotePlayed != 0:
			highgood.hide()
			highbad.show()
			print("no rest")
		else:
			highgood.show()
			highbad.hide()
			highcollisions[0].hide()
			print("yes rest")
			score += 1
	
		highcollisions.remove_at(0)
	highnotePlayed = 0
	highcurrNote = null


func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if "quarter" in body.name:
		medcurrNote = "quarter"
	elif "rest" in body.name:
		medcurrNote = "rest"
	print(medcurrNote)
	#print(body.name)


func _on_rigid_body_2d_body_exited(body: Node) -> void:
	if str(body.name) == "endofsong":
		SignalManager.emit_signal("uptomssongdone")
	elif medcurrNote == "quarter":
		if  mednotePlayed != 1:
			medgood.hide()
			medbad.show()
			print("no hit")
		else:
			medgood.show()
			medbad.hide()
			medcollisions[0].hide()
			print("yes hit")
			score+=1
		medcollisions.remove_at(0)
			
	elif medcurrNote == "rest":
		if mednotePlayed != 0:
			medgood.hide()
			medbad.show()
			print("no rest")
		else:
			medgood.show()
			medbad.hide()
			medcollisions[0].hide()
			print("yes rest")
			score += 1
	
		medcollisions.remove_at(0)
	
	mednotePlayed = 0
	medcurrNote = null

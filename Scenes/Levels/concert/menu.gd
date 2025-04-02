extends Control
@onready var allowed = false
@onready var drawn = false
@onready var menuReqs = GameManager.menuReqs
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("./boundry/e").hide()
	allowed = false
	draw_reqs()
	if GameManager.menuReqs == null:
		menuReqs = generate_menu_reqs()
		GameManager.menuReqs = menuReqs
		print(GameManager.menuReqs)
		draw_reqs()
		
	
func generate_menu_reqs():
	var d = {}
	d["drumallowed"] = true
	d["level"] = GameManager.playerInfo["level"] + 2
	if GameManager.playerInfo["unlocked"]["piano"][0]:
		if GameManager.playerInfo["unlocked"]["drumset"][0]:
			for p in ["bass","snare","hihat","floortom","uptoms"]:
				d[p] = GameManager.instrumentLevels[p] + randi_range(0,3)
			
		else:
			d["piano"] = 7
			for p in ["bass","snare","hihat","floortom","uptoms"]:
				d[p] = "X"
			d["cymbal"] = 2
	else:
		for p in ["bass","snare","hihat","cymbal","floortom","uptoms"]:
			d[p] = "X"
			d["drumallowed"] = false
			
		d["piano"] = 2
	var notes = ["f3","g3","a4","b4","c4","d4","e4","f4","g4","a5"]
	var wanted = []
	for x in range(randi_range(0,len(notes))):
		var t = notes.pick_random()
		notes.erase(t)
		wanted.append(t)
	var notwanted = []
	for x in range(randi_range(0,len(notes))):
		var t = notes.pick_random()
		notes.erase(t)
		notwanted.append(t)
	
	d["pianoReqs"] = {
	}
	
	notes = ["f3","g3","a4","b4","c4","d4","e4","f4","g4","a5"]

	for x in notes:
		if x in wanted:
			d["pianoReqs"][x] = 1
		elif x in notwanted:
			d["pianoReqs"][x] = -1
		else:
			d["pianoReqs"][x] = 0
	return d
	print(d)
	print(GameManager.menuReqs)
	
func draw_reqs():
	if menuReqs == null or drawn: return
	get_node("./min level/level").text = str(menuReqs["level"])
	for x in ["bass","snare","hihat","cymbal","floortom","uptoms","piano"]:
		if x != "piano":
			get_node("./"+x+"/Sprite2D").hide()
		if not str(menuReqs[x]).is_valid_int() and menuReqs[x] == "X":
			get_node("./"+x+"/Sprite2D").show()
			get_node("./"+x).text = "X"
			continue
		get_node("./"+x).text = "Lvl. > " + str(menuReqs[x])
		
	var imagetexturgood = load("res://Assets/Sprites/drumworld/quartergood.png")
	var imagetexturbad = load("res://Assets/Sprites/drumworld/quarterbad.png")
	var positioninggood = {
			"f3":Vector2i(0+270,-150-70),
			"g3":Vector2i(40+270,-138-70),
			"a4":Vector2i(80+270,-126-70),
			"b4":Vector2i(120+270,-114-70),
			"c4":Vector2i(160+270,-102-70),
			"d4":Vector2i(200+270,-90-70),
			"e4":Vector2i(240+270,-78-70),
			"f4":Vector2i(280+270,-66-70),
			"g4":Vector2i(320+270,-54-70),
			"a5":Vector2i(360+270,-42-70)
		}
	var positioningbad = {
			"f3":Vector2i(0+270,-150+95),
			"g3":Vector2i(40+270,-138+95),
			"a4":Vector2i(80+270,-126+95),
			"b4":Vector2i(120+270,-114+95),
			"c4":Vector2i(160+270,-102+95),
			"d4":Vector2i(200+270,-90+95),
			"e4":Vector2i(240+270,-78+95),
			"f4":Vector2i(280+270,-66+95),
			"g4":Vector2i(320+270,-54+95),
			"a5":Vector2i(360+270,-42+95)
		}
	for note in menuReqs["pianoReqs"].keys():
		if menuReqs["pianoReqs"][note] == 0:
			continue
		elif menuReqs["pianoReqs"][note] == -1:
			var s:Sprite2D = Sprite2D.new()
			s.texture = imagetexturbad
			s.position = positioningbad[note]
			s.scale = Vector2(3,3)
			get_node("./piano").add_child(s)
		else:
			var s:Sprite2D = Sprite2D.new()
			s.texture = imagetexturgood
			s.position = positioninggood[note]
			s.scale = Vector2(3,3)
			get_node("./piano").add_child(s)
	drawn = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if allowed and Input.is_action_just_released("select"):
		GameManager.zoomedIn = true
		GameManager.world = "Levels/concert/menu.tscn"
		GameManager.change_scene(GameManager.world)
		allowed = false
	elif GameManager.zoomedIn and Input.is_action_just_released("select"):
		print("exit")
		GameManager.zoomedIn = false
		GameManager.world = "Levels/concert/concert.tscn"
		GameManager.change_scene(GameManager.world)
	
	
func get_info():
	var dict = {}
	dict["min level"] = 5
	return dict


func _on_boundry_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	get_node("./boundry/e").show()
	allowed = true


func _on_boundry_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	get_node("./boundry/e").hide()
	allowed = false

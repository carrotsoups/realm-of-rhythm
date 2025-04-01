extends Node2D

@onready var world_music = $LittleRootTownMusic
@onready var isInfoOpen = false
@onready var infoRect:Node2D = get_node("./Player/Camera2D/Info")


func _ready():
	var temppos = GameManager.playerpos
	temppos.x -= 10
	temppos.y += 10
	get_node("./Player").position = temppos
	
	world_music.play()
	infoRect.hide()
	infoRect.scale = Vector2(0.3,0.3)
	SignalManager.connect("pianoworldunlocked",unlock_piano)
	
func unlock_piano():
	var e:AnimatedSprite2D = get_node("./Player/Camera2D/unlocking")
	await get_tree().create_timer(1).timeout
	e.show()
	await get_tree().create_timer(2).timeout
	e.play()
	print("unlocked piano")
	await get_tree().create_timer(3).timeout
	e.hide()
	get_node("./Player/Camera2D/piano").show()
	await get_tree().create_timer(3).timeout
	get_node("./Player/Camera2D/piano").hide()
	GameManager.playerInfo["unlocked"]["piano"][0] = true

func _process(delta):
	# control de music playin
	if GameManager.is_battle and world_music.is_playing():
		world_music.stop()
	if !GameManager.is_battle and !world_music.is_playing():
		world_music.play()
	
	if Input.is_action_just_pressed("open_menu"):
		isInfoOpen = not isInfoOpen
		if isInfoOpen:
			infoRect.show()
		else:
			infoRect.hide()



func _on_pianoworldarea_body_entered(body: Node2D) -> void:
	if body.name == "Player" and GameManager.playerInfo["unlocked"]["piano"][0]:
		GameManager.world = "Levels/piano/pianoworld.tscn"
		GameManager.playerpos = get_node("./Player").position
		GameManager.change_scene(GameManager.world)

func _on_pianoworldarea_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_drumworldarea_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player" and GameManager.playerInfo["unlocked"]["drumset"][0]:
		var allUnlocked = true
		for state in  GameManager.playerInfo["unlocked"]["drumset"][1].values():
			if not state:
				allUnlocked = false
				break
		if allUnlocked:
			GameManager.world = "Levels/drum/drumunlocked.tscn"
		else:
			GameManager.world = "Levels/drum/drumworld.tscn"
		GameManager.playerpos = get_node("./Player").position
		GameManager.change_scene(GameManager.world)


func _on_concertarea_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		GameManager.world = "Levels/concert/concert.tscn"
		GameManager.playerpos = get_node("./Player").position
		GameManager.change_scene(GameManager.world)

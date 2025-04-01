extends Node2D

var turn = "player"
var is_battle = false
var is_dialog = false
var world = "/Levels/world.tscn"
var pathlight = "root/Scenes/Pianoworld/light_up/"
var pathanim = "root/Scenes/Pianoworld/tile_animations/"
var pathplay = "root/Scenes/Pianoworld/Notes/"
var notes = {}
var songLength = 0
var playerpos = Vector2(138,54)
var instrumentLevels = {
		"cymbal":1,
		"hihat":1,
		"bass":1,
		"uptoms":1,
		"floortom":1,
		"snare":1,
		"piano":1,
}
var playerInfo = {
	"level": 1,
	"xp": 0,
	"maxXP":100,
	"hp":0,
	"maxHP":0,
	"unlocked":{
		"piano":[false,{
			"level":1,
			"xp":0,
			"maxXP":25,
		}],
		"drumset":[false,{
			"cymbal":false,
			"hihat":false,
			"bass":false,
			"uptoms":false,
			"floortom":false,
			"snare":false,
		}]
	}
}
@onready var played = {"piano":[],"drum":[]}

func change_scene(scene):
	get_tree().change_scene_to_file("res://scenes/"+scene)
func loadplayer():
	var playerinst = load("res://Scenes/Player/player.tscn").instantiate()
	playerinst.set_script(load("res://Player/Player.gd"))
	return playerinst
func _ready() -> void:
	is_battle = false
	SignalManager.connect("xp_changed",update_level)
	SignalManager.connect("send_played",add_to_list)
func _process(delta: float) -> void:
	if not playerInfo["unlocked"]["piano"][0] and playerInfo["level"] >= 5:
		SignalManager.emit_signal("pianoworldunlocked")
		playerInfo["unlocked"]["piano"][0] = true
	if not GameManager.playerInfo["unlocked"]["drumset"][0] and instrumentLevels["piano"] >= 2:
		GameManager.playerInfo["unlocked"]["drumset"][0] = true
		SignalManager.emit_signal("drumworldunlocked")
		
	
func add_to_list(instrument:String, note:String):
	if instrument == "piano":
		played["piano"].append(note)
	else:
		played["drum"].append(instrument)

func update_level():
	if playerInfo["xp"] >= playerInfo["maxXP"]:
		playerInfo["xp"] -= playerInfo["maxXP"]
		playerInfo["level"] += 1
		playerInfo["maxXP"] = int((1.25**playerInfo["level"])*100)
		
		

	

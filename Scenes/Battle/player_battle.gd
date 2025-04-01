extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var attack_damage = 4
@onready var hp_bar = $PlayerHPBar
@onready var xp_bar = $PlayerXPBar
@onready var level = $PlayerLv
@onready var playerInfo = GameManager.playerInfo
@export var max_hp = 25
var hp = 25
var is_alive = true

func _ready():
	SignalManager.connect("player_hp_changed", on_player_hp_changed)
	hp = playerInfo["hp"]
	hp_bar.max_value = playerInfo["maxHP"]
	hp_bar.value = hp
	level.text =  str(playerInfo["level"])
	xp_bar.value = playerInfo["xp"]
	xp_bar.max_value = playerInfo["maxXP"]
	is_alive = true
	

func get_hp():
	return hp

func _process(delta):
	if hp <= 0 and is_alive:
		print("player is dead")
		SignalManager.emit_signal("player_dead")
		is_alive = false
	else:
		is_alive = true
		
func on_player_hp_changed(new_hp):
	hp -= new_hp
	hp_bar.value = hp
	playerInfo["hp"] = hp
	GameManager.playerInfo = playerInfo
	print(hp)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "tackle":
		SignalManager.emit_signal("player_animation_finished")
	if anim_name == "thunder":
		SignalManager.emit_signal("player_animation_finished")

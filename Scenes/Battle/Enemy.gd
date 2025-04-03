extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var attack_percent = 1
@onready var buff = 1.15
@onready var hp_bar = $EnemyHPBar
@onready var level_text:Label = $EnemyLv
@onready var level = int(rand_relativeto_player(GameManager.playerInfo["level"]))
@export var max_hp = 0
@export var hp = 0
var is_alive = true

func rand_relativeto_player(initial:int)->int:
	return randf_range(0.6,1.25)*(initial+1)

func _ready():
	SignalManager.connect("enemy_hp_changed", on_enemy_hp_changed)
	max_hp = int(rand_relativeto_player(GameManager.playerInfo["maxHP"]))
	hp = max_hp
	hp_bar.max_value = max_hp
	hp_bar.value = max_hp
	#level = int(rand_relativeto_player(GameManager.playerInfo["level"]))
	attack_percent = GameManager.playerInfo["level"]/level
	level_text.text = str(level)

func get_hp():
	return hp

func _process(delta):
	if hp <= 0 and is_alive:
		SignalManager.emit_signal("enemy_dead")
		print("enemy is dead")
		is_alive = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hit":
		animation_player.play("attack")
		
	if anim_name == "attack":
		SignalManager.emit_signal("enemy_animation_finished")

func on_enemy_hp_changed(new_hp):
	hp -= int(new_hp*attack_percent*buff)
	hp_bar.value = hp
	print(hp)

@tool
extends Control

@onready var enemy = $CanvasLayer/Enemy
@onready var attack1_btn = $CanvasLayer/UI/PlayerMenu/FightMenu/AttackBtn1
@onready var attack2_btn = $CanvasLayer/UI/PlayerMenu/FightMenu/AttackBtn2
@onready var attack3_btn = $CanvasLayer/UI/PlayerMenu/FightMenu/AttackBtn3
@onready var enemy_hp_bar = $CanvasLayer/Enemy/EnemyHPBar
@onready var anim = $CanvasLayer/AnimationPlayer
@onready var text_timer = $CanvasLayer/UI/DialogBox/TextTimer
@onready var dialog =$CanvasLayer/UI/DialogBox/RichTextLabel
@onready var dialog_box = $CanvasLayer/UI/DialogBox
@onready var click_to_continue = $CanvasLayer/UI/DialogBox/ContinueArrow
@onready var menu = $CanvasLayer/UI/PlayerMenu
@onready var menu_arrow = $CanvasLayer/UI/PlayerMenu/FightMenu/MenuArrow
@onready var player = $CanvasLayer/Player
@onready var canvas = $CanvasLayer

@export var text_speed = 0.07

var text_num = 0
var is_dialog_finished = false
var is_menu_visible = false
var begin_battle = false

var thunder_scene = preload("res://Scenes/Battle/ThunderShock.tscn")

func _ready():
	SignalManager.connect("btn_pos", move_menu_arrow)
	SignalManager.connect("player_animation_finished", on_player_animation_finished)
	SignalManager.connect("enemy_animation_finished", on_enemy_animation_finished)
	SignalManager.connect("enemy_dead", on_enemy_dead)
	SignalManager.connect("player_dead", on_player_dead)
	anim.play("fade_in")
	dialog_box.visible = true
	dialog.visible = false
	#$BattleMusic.play()

func _process(_delta):
	click_to_continue.visible = is_dialog_finished
	
	if begin_battle:
		show_dialog("🎵🎵🎵🎵🎵🎵🎵🎵")
		begin_battle = false
		
	if Input.is_action_just_pressed("ui_accept") and !is_menu_visible and enemy.hp > 0:
		if is_dialog_finished:
			dialog.visible = false
			dialog_box.visible = false
			click_to_continue.visible = false
			anim.play("hide")
			menu.visible = true
			is_menu_visible = true
			attack1_btn.grab_focus()
		else:
			dialog.visible_characters = dialog.text.length()

func on_enemy_dead():
	# exit battle
	print("dead")
	show_dialog("OOO")
	GameManager.playerInfo["xp"] += int(enemy.level*enemy.attack_percent*65)
	SignalManager.xp_changed.emit()
	anim.play("fade_out")
	GameManager.is_battle = false
	var batttle = get_node("Player/Battle")
	player.remove_child(batttle)

func on_player_dead():
	show_dialog("🪫🪫🪫")
	anim.play("fade_out")
	print("died")
	GameManager.is_battle = false
	var batttle = get_node("Player/Battle")
	player.remove_child(batttle)

	
func move_menu_arrow(x,y):
	# position the arrow on the menu 
	menu_arrow.global_position.x = x
	menu_arrow.global_position.y = y

func show_dialog(custom_text):
	# show dialog box with custom text.
	GameManager.is_dialog = true
	dialog_box.visible = true
	menu.visible = false
	dialog.visible = true
	is_dialog_finished = false
	click_to_continue.visible = true
	text_timer.wait_time = text_speed
	anim.play("blink")
	next_text()
	dialog.text = str(custom_text)

func next_text() -> void:
	# animate the dialog text
	"""if text_num >= dialog.text.length():
		dialog.text = ""
		return"""
	
	is_dialog_finished = false
	
	dialog.visible_characters = 0
		
	while dialog.visible_characters < dialog.text.length():
		dialog.visible_characters += 1
		
		text_timer.start()
		await text_timer.timeout
	
	is_dialog_finished = true
	#text_num += 1
	
	return

func _on_attack_btn_1_pressed():
	is_menu_visible = false
	player.animation_player.play("tackle")
	await get_tree().create_timer(1.0).timeout 
	var attack_value = int(enemy.attack_percent*20)
	show_dialog(str(attack_value))
	SignalManager.enemy_hp_changed.emit(attack_value)
	print(1)
func _on_attack_btn_2_pressed():
	is_menu_visible = false
	player.animation_player.play("thunder")
	var thunder_instance = thunder_scene.instantiate()
	canvas.add_child(thunder_instance)
	thunder_instance.position = $CanvasLayer/FX_pos.position	
	await get_tree().create_timer(1.0).timeout 
	var attack_value = int(enemy.attack_percent*15)
	show_dialog(str(attack_value))
	SignalManager.enemy_hp_changed.emit(attack_value)
	print(2)
	

func _on_attack_btn_3_pressed():
	is_menu_visible = false
	player.animation_player.play("tackle")
	await get_tree().create_timer(1.0).timeout
	var attack_value = int(enemy.attack_percent*8)
	show_dialog(str(attack_value))
	SignalManager.enemy_hp_changed.emit(attack_value)
	print("3")

func _on_run_btn_pressed():
	show_dialog("🚗💨")
	anim.play("fade_out")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		GameManager.is_battle = false
		queue_free()
		
	if anim_name == "fade_in":
		begin_battle = true

func on_enemy_turn():
	if enemy.hp > 0:
		var cost = int(11*randf_range(0.5,1.5))
		
		show_dialog(str(cost))
		
		SignalManager.player_hp_changed.emit(cost)
		await get_tree().create_timer(1.0).timeout 
		enemy.animation_player.play("attack")
		await get_tree().create_timer(1.0).timeout 

func on_player_animation_finished():
	enemy.animation_player.play("hit")
	await get_tree().create_timer(1.0).timeout 
	GameManager.turn = "enemy"
	await on_enemy_turn()

func on_enemy_animation_finished():
	GameManager.turn = "player"

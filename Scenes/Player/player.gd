extends CharacterBody2D

# player variables
@export var speed = 40
@export var max_speed = 100
@export var FRICTION: float = 0.15
var is_alive = true
var move_direction = Vector2.ZERO

# tile data
var is_on_tall_grass
var current_tile: Vector2i
#@onready var tilemap = get_tree().get_nodes_in_group("tiles")[0]

# battle variables
var rng = RandomNumberGenerator.new()
var random_encounter
var battle_scene = preload("res://Scenes/Battle/battle.tscn")
var probability = 0.85


func _ready():
	SignalManager.connect("instantiate_battle", battle)
	randomize()
	
func _process(delta):
	get_input()
	
func _physics_process(delta):
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	
	if !GameManager.is_battle:
		move()
		#get_tile_below_player()
	
func get_input():
	if GameManager.is_battle:
		move_direction = Vector2.ZERO
	else:
		# movement
		if Input.is_action_pressed("move_down"):
			move_direction = Vector2.DOWN
			$AnimatedSprite2D.flip_v = false
			$AnimationPlayer.play("down")
		elif Input.is_action_pressed("move_up"):
			move_direction = Vector2.UP
			$AnimatedSprite2D.flip_v = false
			$AnimationPlayer.play("up")
			#$AnimationPlayer.play("up")
		elif Input.is_action_pressed("move_left"):
			move_direction = Vector2.LEFT
			$AnimatedSprite2D.flip_h = true
			$AnimationPlayer.play("left")
		elif Input.is_action_pressed("move_right"):
			move_direction = Vector2.RIGHT
			$AnimatedSprite2D.flip_h = false
			$AnimationPlayer.play("left")

		# Idle animations
		if Input.is_action_just_released("move_down"):
			move_direction = Vector2.ZERO
			$AnimationPlayer.play("idle_down")
		if Input.is_action_just_released("move_up"):
			move_direction = Vector2.ZERO
			$AnimationPlayer.play("idle_down")
		if Input.is_action_just_released("move_left"):
			move_direction = Vector2.ZERO
			$AnimationPlayer.play("idle_down")
		if Input.is_action_just_released("move_right"):
			move_direction = Vector2.ZERO
			$AnimationPlayer.play("idle_down")

func move():
	move_direction = move_direction.normalized()
	velocity += move_direction * speed 
	velocity = velocity.limit_length(max_speed)
	move_and_slide()

"""
func get_tile_below_player():
	# get tile data
	var tile_below: Vector2i = tilemap.local_to_map(position) 
	var tile_data: TileData = tilemap.get_cell_tile_data(0, tile_below)
	
	# check if player is on the same tile
	if current_tile != tile_below and tile_data:
		current_tile = tile_below
		print(current_tile)
		
		# check if tile is tall grass
		is_on_tall_grass = tile_data.get_custom_data("tall_grass")
		print("is on tall grass")
		
		# calculate probability of a random encounter
		random_encounter = randf()
		print(random_encounter)
		if random_encounter > probability:
			battle()
	else:
		is_on_tall_grass = false
	"""


func battle():
	# instantiate the battle scene
	GameManager.is_battle = true
	var battle_instance = battle_scene.instantiate()
	add_child(battle_instance)

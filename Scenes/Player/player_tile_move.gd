extends Area2D

@onready var ray = $RayCast2D

# tile-by-tile movement
@export var tile_size = 16 # change this value to match the size of your tiles
@export var animation_speed = 3
var inputs = {"move_right": Vector2.RIGHT, "move_left": Vector2.LEFT, "move_up": Vector2.UP, "move_down": Vector2.DOWN}
var moving = false

func _ready():
	#round the position to the nearest tile increment
	position = position.snapped(Vector2.ONE * tile_size) 
	position += Vector2.ONE * tile_size/2

func _process(delta):
	# Idle animations
	if Input.is_action_just_released("move_down"):
		$AnimationPlayer.play("idle_down")
	if Input.is_action_just_released("move_up"):
		$AnimationPlayer.play("idle_up")
	if Input.is_action_just_released("move_left"):
		$AnimationPlayer.play("idle_left")
	if Input.is_action_just_released("move_right"):
		$AnimationPlayer.play("idle_right")

func _unhandled_input(event):
	if moving:
		return
		
	for dir in inputs.keys():
		if event.is_action(dir):
			move(dir)
			if dir == "move_right":
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			$AnimationPlayer.play(dir)
			
func move(dir):
	ray.target_position = inputs[dir] * tile_size
	# recalculate collisions
	ray.force_raycast_update()
	if !ray.is_colliding():
		var tween = create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size, 0.9 / animation_speed).set_trans(Tween.TRANS_LINEAR)
		moving = true
		await tween.finished
		moving = false

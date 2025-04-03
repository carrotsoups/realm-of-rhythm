extends Node2D
@onready var charging = false
@onready var timer:Timer = get_node("./Timer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("./battery/player").hide()
	timer.wait_time = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("select"):
		GameManager.world = "Levels/charge/charge.tscn"
		GameManager.change_scene(GameManager.world)
		
	if Input.is_action_just_released("charge"):
		if charging:
			stopcharging()
		else:
			startcharging()
			
	if GameManager.playerInfo["hp"]*2 <  GameManager.playerInfo["maxHP"]:
		get_node("./battery/").text = "🪫"
	else:
		get_node("./battery/").text = "🔋"

func stopcharging():
	charging = false
	get_node("./battery/player").hide()
	
func wait():
	timer.start()
	print(timer.time_left)
	print("timerstarted")
	await timer.timeout
	timer.stop()
	return true
func startcharging():
	charging = true
	get_node("./battery/player").show()
	while GameManager.playerInfo["hp"] <  GameManager.playerInfo["maxHP"]:
		await wait()
		print("done timing")
		GameManager.playerInfo["hp"] += 1
		print("added")
	stopcharging()

extends Path2D
@onready var path = get_node("./PathFollow2D")
var playthrough = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.connect("song_length",addEndPoint)
	
func addEndPoint(n):
	curve.add_point(Vector2i(n,0),Vector2i(0,0),Vector2i(0,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if 0.999 <= path.progress_ratio:
		playthrough = true
	elif not playthrough:
		path.progress_ratio += 0.06*delta

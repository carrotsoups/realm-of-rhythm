extends Camera2D

@onready var top_left = $Limits/TopLeft
@onready var bottom_right = $Limits/BottomRight

var zoom_out = Vector2(1,1)
var zoom_in = Vector2(2,2)


func _ready():
	# set camera limits
	"""limit_top = top_left.position.y
	limit_left = top_left.position.x
	limit_bottom = bottom_right.position.y
	limit_right = bottom_right.position.x"""

func _process(delta):
	if GameManager.is_battle:
		set_zoom(zoom_out)
	elif !GameManager.is_battle:
		set_zoom(zoom_in)

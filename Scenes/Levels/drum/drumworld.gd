extends Node2D

@onready var eButt = get_node("./Player/e")
@onready var eIsVis = false
@onready var player = get_node("./Player")
@onready var parts = ["bass","snare","hihat","cymbal","floortom","uptoms"]
@onready var drumset = {
	"bass":get_node("./orgs/bass"),
	"cymbal":get_node("./orgs/cymbal"),
	"floortom":get_node("./orgs/floortom"),
	"hihat":get_node("./orgs/hihat"),
	"snare":get_node("./orgs/snare"),
	"uptoms":get_node("./orgs/uptoms")
}
@onready var isInfoOpen = false
@onready var infoRect:Node2D = get_node("./Player/Info")


func _ready():
	var imagespath = "./orgs/images/"
	for part in parts:
		var ppath = imagespath+part
		var ddrum = get_node(ppath)
		if GameManager.playerInfo["unlocked"]["drumset"][1][part]:
			ddrum.hide()
		else:
			ddrum.show()
	infoRect.hide()
	eButt.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	eIsVis = false
	for instru in drumset.keys():
		if drumset[instru].overlaps_body(player):
			eIsVis = true
			if Input.is_action_just_released("select"):
				GameManager.world = "Levels/drum/"+instru+"train.tscn"
				GameManager.change_scene(GameManager.world)
				
			break
	if eIsVis:
		eButt.show()
	else:
		eButt.hide()
	
	if Input.is_action_just_pressed("open_menu"):
		isInfoOpen = not isInfoOpen
		if isInfoOpen:
			infoRect.show()
		else:
			infoRect.hide()
		
	
		
	


func _on_home_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		GameManager.world = "Levels/world.tscn"
		GameManager.change_scene(GameManager.world)


func _on_bass_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	eIsVis = true 


func _on_cymbal_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	eIsVis = true


func _on_floortom_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	eIsVis = true


func _on_hihat_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	eIsVis = true


func _on_snare_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	eIsVis = true


func _on_uptoms_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	eIsVis = true


func _on_bass_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	eIsVis = false


func _on_cymbal_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	eIsVis = false


func _on_floortom_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	eIsVis = false


func _on_hihat_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	eIsVis = false


func _on_snare_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	eIsVis = false


func _on_uptoms_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	eIsVis = false

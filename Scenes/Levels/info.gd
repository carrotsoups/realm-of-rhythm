extends Node2D
@onready var level = get_node("./info/Level")
@onready var hp_bar = $info/HP/PlayerHPBar
@onready var xp_bar = $info/Exp/PlayerXPBar
@onready var playerInfo = GameManager.playerInfo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	var hp = playerInfo["hp"]
	xp_bar.value = playerInfo["xp"]
	xp_bar.max_value = playerInfo["maxXP"]
	hp_bar.max_value = playerInfo["maxHP"]
	hp_bar.value = hp
	level.text =  str("Lvl. " + str(playerInfo["level"]))
	
	
	$info/HP/ratio.text = str(playerInfo["hp"]) + " / " + str(playerInfo["maxHP"])
	$info/Exp/ratio.text = str(playerInfo["xp"]) + " / " + str(playerInfo["maxXP"])
	var instruments =  ["bass","snare","hihat","cymbal","floortom","uptoms","piano"]
	for i in instruments:
		if i == "piano":
			if GameManager.playerInfo["unlocked"]["piano"][0]:
				get_node("./info/"+i).show()
				get_node("./info/"+i).text = "Lvl. "+ str(GameManager.instrumentLevels[i])
			else:
				get_node("./info/"+i).hide()
		else:		
			if GameManager.playerInfo["unlocked"]["drumset"][1][i]:
				get_node("./info/"+i).show()
				get_node("./info/"+i).text = "Lvl. "+ str(GameManager.instrumentLevels[i])
			else:
				get_node("./info/"+i).hide()

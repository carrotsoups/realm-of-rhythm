extends Node
# this global script is used to manage the signals of every entity

# signals
signal player_hp_changed(value)
signal enemy_hp_changed(value)
signal enemy_animation_finished
signal player_animation_finished
signal enemy_dead
signal player_dead
signal instantiate_battle
signal btn_pos(x,y)
signal recordednotes(n:String)
signal song(s)
signal xp_changed
signal song_length(n:int)
signal cymbalsongdone()
signal hihatsongdone()
signal basssongdone()
signal snaresongdone()
signal uptomssongdone()
signal floortomsongdone()
signal send_played(instrument:String,note:String)
signal pianoworldunlocked()
signal button_clicked()
signal recordingstatechanged(state:String)
signal drumworldunlocked()
signal concertscore(score:Dictionary)

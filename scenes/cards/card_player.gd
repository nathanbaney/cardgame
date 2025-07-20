class_name CardPlayer extends Node

# Contains state for a single player in a card game. Has the player's deck,
# hand, discard pile, play zone, life total, etc

@export var life_total: int = 20
@export var is_human: bool = false

var is_loser: bool = false
var draw_per_turn: int = 3

func change_health(delta: int):
	life_total += delta
	#emit a signal for ui

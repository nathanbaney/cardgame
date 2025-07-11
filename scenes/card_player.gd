class_name CardPlayer extends Node

# Contains state for a single player in a card game. Has the player's deck,
# hand, discard pile, play zone, life total, etc

@export var life_total: int = 20
@export var deck: CardPile
@export var hand: CardPile
@export var discard_pile: CardPile
@export var play_zone: CardPile

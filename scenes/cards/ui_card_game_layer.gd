extends Control

@onready var card_manager = $CardManager
@onready var card_factory = $CardManager/CustomJsonCardFactory
@onready var player_hand = $CardManager/PlayerHand
@onready var player_deck = $CardManager/PlayerDeck
@onready var player_field = $CardManager/PlayerField
@onready var player_discard = $CardManager/PlayerDiscard
@onready var opponent_hand = $CardManager/OpponentHand
@onready var opponent_deck = $CardManager/OpponentDeck
@onready var opponent_field = $CardManager/OpponentField
@onready var opponent_discard = $CardManager/OpponentDiscard

func _ready():
	_reset_deck()

func _reset_deck():
	var list = _get_randomized_card_list()
	player_deck.clear_cards()
	for card in list:
		card_factory.create_card(card, player_deck)

func _get_randomized_card_list() -> Array:
	
	var card_list = []
	for ii in range(1, 8):
		card_list.append("%s" % ii)
	
	card_list.shuffle()
	
	return card_list


func _on_button_pressed() -> void:
	player_hand.move_cards(player_deck.get_top_cards(7))

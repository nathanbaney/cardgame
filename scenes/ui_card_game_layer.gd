extends Control

@onready var card_manager = $CardManager
@onready var card_factory = $CardManager/MyCardFactory
@onready var hand = $CardManager/Player1Hand
@onready var deck = $CardManager/Player1Deck

func _ready():
	_reset_deck()

func _reset_deck():
	var list = _get_randomized_card_list()
	deck.clear_cards()
	for card in list:
		card_factory.create_card(card, deck)

func _get_randomized_card_list() -> Array:
	var suits = ["club", "spade", "diamond", "heart"]
	var values = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
	
	var card_list = []
	for suit in suits:
		for value in values:
			card_list.append("%s_%s" % [suit, value])
	
	card_list.shuffle()
	
	return card_list

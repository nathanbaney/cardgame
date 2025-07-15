class_name UICardHand extends Control

# UI element that has an Array of Cards, which get displayed as an Array of UICards

var cards_in_hand: Array[UICard] = []
var deck_position: Vector2 = Vector2(1, 1)
@export var is_hidden: bool = true

func draw_card(card: Card) -> void:
	# make UICard from card, append UICard to cards_in_hand, move UICard from deck to hand area
	var uicard: UICard = UICard.new()
	uicard.initialize(card)
	self.add_child(uicard)
	cards_in_hand.append(uicard)
	pass

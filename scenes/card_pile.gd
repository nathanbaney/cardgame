class_name CardPile extends Node

# Ordered list of cards with supporting operations. Inherited by Hand, Deck, PlayZone

@export var cards: Array[Card] = []

func deal_cards(number_of_cards: int) -> Array[Card]:
	var dealt_cards: Array[Card] = []
	for ii in range(number_of_cards):
		if not cards.is_empty():
			dealt_cards.append(cards.pop_front())
	return dealt_cards

#should empty deck check be here? or in gamestate?
func deal_card():
	if not cards.is_empty():
		return cards.pop_front()

func shuffle() -> void:
	cards.shuffle() #consider seeding

func search_by_name(card_name: String): #returns Card or null if no card is found with that name
	for card in cards:
		if card.card_name == card_name:
			return card
	return null

func search_by_id(card_id: int):
	for card in cards:
		if card.card_id == card_id:
			return card
	return null

class_name UICard extends Control

var card_data: Card

func _init(card: Card) -> void:
	card_data = card
	$Label.text = card.card_name
	$ColorRect.color = card.card_color

class_name UICard extends Control

var card_data: Card
var card_size: Vector2 = Vector2(200, 300)

func initialize(card: Card = null):
	if not card == null:
		card_data = card
	else:
		print("tried to init a null card, uwu fucky wucky")
	var label: Label = Label.new()
	label.text = card_data.card_name
	var rect: ColorRect = ColorRect.new()
	rect.color = card_data.card_color
	rect.size = card_size
	rect.add_child(label)
	add_child(rect)

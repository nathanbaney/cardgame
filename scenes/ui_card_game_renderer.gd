class_name UICardGameRenderer extends Control

var card_scene: PackedScene = preload("res://scenes/ui_card.tscn")

func _on_drew_card(player_index: int, card: Card):
	var uicard: UICard = card_scene.instantiate()
	uicard.initialize(card)
	if player_index == 0:
		self.get_node("UICardHandPlayer").add_card(uicard)
	else:
		self.get_node("UICardHandOpp").add_card(uicard)

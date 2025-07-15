class_name UICardGameRenderer extends Control







func _on_drew_card(player_index: int, card: Card):
	print("ui received card draw signal")
	var uicard: UICard = UICard.new(card)
	if player_index == 0:
		self.get_node("UICardHandPlayer").add_child(uicard)
	else:
		self.get_node("UICardHandOpp").add_child(uicard)

class_name UICardHand extends Control

@export var is_hidden: bool = true
var center_point: Vector2


func _ready() -> void:
	#center_point = Vector2(self.position.x + (self.size.x / 2), self.position.y + (self.size.y / 2))
	center_point = Vector2(self.size.x / 2, 0)
	print("CENTER POINT OF HAND ", center_point)

func add_card(card: UICard) -> void:
	#card.set_position(center_point)
	add_child(card)

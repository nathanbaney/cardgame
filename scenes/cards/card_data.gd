class_name CardData extends Node

@export var card_id: int = -1 #should be unique per card?
@export var card_name: String = "Undefined" #eventually this should be stringIDs for i18n
@export var card_color: Color = Color.DARK_ORANGE #eventually will be enum'd

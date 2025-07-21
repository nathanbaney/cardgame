class_name TradingCard extends Card

@onready var card_frame: TextureRect = $FrontFace/TextureRect
@onready var card_color_overlay: ColorRect = $FrontFace/ColorOverlay
@onready var card_art: TextureRect = $FrontFace/CardArt
@onready var name_label: RichTextLabel = $FrontFace/NameLabel
@onready var effect_label: RichTextLabel = $FrontFace/EffectLabel
@onready var cost_label: RichTextLabel = $FrontFace/CostLabel
@onready var type_label: RichTextLabel = $FrontFace/TypeLabel

const COLOR_RED_NAME: String = "RED"
const COLOR_BLUE_NAME: String = "BLUE"
const COLOR_YELLOW_NAME: String = "YELLOW"
const COLOR_BROWN_NAME: String = "BROWN"
const COLOR_GREEN_NAME: String = "GREEN"
const COLOR_PURPLE_NAME: String = "PURPLE"
const COLOR_WHITE_NAME: String = "WHITE"
const COLOR_COLORLESS_NAME: String = "COLORLESS"

const COLOR_RED: Color = Color(Color.RED, 0.2)
const COLOR_BLUE: Color = Color(0, 0, 1, 0.3)
const COLOR_YELLOW: Color = Color(1, 1, 0, 0.3)
const COLOR_BROWN: Color = Color(0.647059, 0.164706, 0.164706, 0.3)
const COLOR_GREEN: Color = Color(0, 1, 0, 0.3)
const COLOR_PURPLE: Color = Color(0.4, 0.2, 0.6, 0.3)
const COLOR_WHITE: Color = Color(0.980392, 0.921569, 0.843137, 0.3)
const COLOR_COLORLESS: Color = Color(0.662745, 0.662745, 0.662745, 0.3)

func set_faces(front_face: Texture2D, back_face: Texture2D) -> void:
	if front_face:
		card_art.texture = front_face
	back_face_texture.texture = back_face

func set_front_face_from_info(card_info: Dictionary):
	var name_string: String = card_info.get("name")
	var effect_string: String = card_info.get("effect_text")
	var cost_string: String = String.num(card_info.get("cost"))
	#TODO var type_string: String = card_info.get("type")
	var color_string: String = card_info.get("color")
	
	name_label.text = name_string
	effect_label.text = effect_string
	cost_label.text = cost_string
	#TODO type_label.text = type_string
	
	set_front_face_color(color_string)


func set_front_face_color(color: String):
	match color:
		COLOR_RED_NAME:
			card_color_overlay.color = Color.RED
		COLOR_BLUE_NAME:
			card_color_overlay.color = Color.BLUE
		COLOR_YELLOW_NAME:
			card_color_overlay.color = Color.YELLOW
		COLOR_BROWN_NAME:
			card_color_overlay.color = Color.BROWN
		COLOR_GREEN_NAME:
			card_color_overlay.color = Color.GREEN
		COLOR_PURPLE_NAME:
			card_color_overlay.color = Color.PURPLE
		COLOR_WHITE_NAME:
			card_color_overlay.color = Color.ANTIQUE_WHITE
		_:
			card_color_overlay.color = Color.DARK_GRAY
	
	card_color_overlay.color

@tool
class_name CustomJsonCardFactory
extends CardFactory

## a base card scene to instantiate.
@export var default_card_scene: PackedScene
## card image asset directory
@export var card_asset_dir: String
## card information json directory
@export var card_info_dir: String
## common back face image of cards
@export var back_image: Texture2D

var all_card_info: Dictionary


func _ready() -> void:
	if default_card_scene == null:
		push_error("default_card_scene is not assigned!")
		return
		
	var temp_instance = default_card_scene.instantiate()
	if not (temp_instance is Card):
		push_error("Invalid node type! default_card_scene must reference a Card.")
		default_card_scene = null
	temp_instance.queue_free()
	
	preload_card_data()

#TODO refactor card_id to be int (need to dump examples first)
func create_card(card_name: String, target: CardContainer) -> Card:
	# check card info is cached
	if preloaded_cards.has(card_name):
		var card_info = preloaded_cards[card_name]["info"]
		var front_image = preloaded_cards[card_name]["texture"]
		return _create_card_node(card_info.name, front_image, target, card_info)
	else:
		var card_info = get_card_info(card_name)
		if card_info == null or card_info == {}:
			push_error("Card info not found for card: %s" % card_name)
			return null

		#if not card_info.has("front_image"):
		#	push_error("Card info does not contain 'front_image' key for card: %s" % card_name)
		#	return null
		#var front_image_path = card_asset_dir + "/" + card_info["front_image"]
		#var front_image = _load_image(front_image_path)
		#if front_image == null:
		#	push_error("Card image not found: %s" % front_image_path)
		#	return null

		#TODO add card art asset loading

		return _create_card_node(card_info.name, null, target, card_info)


func preload_card_data() -> void:
	all_card_info = _load_card_info()
	
	#TODO do i need any of this nonsense?
	#var dir = DirAccess.open(card_info_dir)
	#if dir == null:
	#	push_error("Failed to open directory: %s" % card_info_dir)
	#	return

	#dir.list_dir_begin()
	#var file_name = dir.get_next()
	#while file_name != "":
	#	print("loading file ", file_name)
	#	if !file_name.ends_with(".json"):
	#		file_name = dir.get_next()
	#		continue

	#	all_card_info = _load_card_info()
	#	if all_card_info == null:
	#		push_error("Failed to load card info for %s" % file_name)
	#		continue

		#TODO front image stuff
		#var front_image_path = card_asset_dir + "/" + card_info.get("front_image", "")
		#var front_image_texture = _load_image(front_image_path)
		#if front_image_texture == null:
		#	push_error("Failed to load card image: %s" % front_image_path)
		#	continue

		#preloaded_cards[card_name] = {
		#	"info": card_info,
		#	"texture": null
		#}
		#print("Preloaded card data:", preloaded_cards[card_name])
		
	#	file_name = dir.get_next()

#TODO refactor card_id to string
func get_card_info(card_id: String) -> Dictionary:
	print("card id: ", card_id)
	print("all card info: ", all_card_info)
	if all_card_info == null or all_card_info == {}:
		push_error("all_card_info is null or empty")
		pass
	return all_card_info.get(card_id)
	

func _load_card_info() -> Dictionary:
	print("made it this far!")
	if !FileAccess.file_exists(card_info_dir):
		return {}

	var file = FileAccess.open(card_info_dir, FileAccess.READ)
	var json_string = file.get_as_text()
	print("json string: ", json_string)
	file.close()

	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		push_error("Failed to parse JSON: %s" % card_info_dir)
		return {}

	return json.data


func _load_image(image_path: String) -> Texture2D:
	var texture = load(image_path) as Texture2D
	if texture == null:
		push_error("Failed to load image resource: %s" % image_path)
		return null
	return texture


func _create_card_node(card_name: String, front_image: Texture2D, target: CardContainer, card_info: Dictionary) -> Card:
	var card = _generate_card(card_info)
	
	if !target._card_can_be_added([card]):
		print("Card cannot be added: %s" % card_name)
		card.queue_free()
		return null
	
	card.card_info = card_info
	card.card_size = card_size
	var cards_node = target.get_node("Cards")
	cards_node.add_child(card)
	target.add_card(card)
	card.card_name = card_name
	card.set_faces(front_image, back_image)
	card.scale = Vector2(2,2)
	card.set_front_face_from_info(card_info)

	return card


func _generate_card(_card_info: Dictionary) -> TradingCard:
	if default_card_scene == null:
		push_error("default_card_scene is not assigned!")
		return null
	return default_card_scene.instantiate()

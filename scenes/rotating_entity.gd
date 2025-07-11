class_name RotatingEntity extends Node3D

# Class to be inherited by all rotating sprites. 
# All inheritors MUST have a spritesheet with all facing angles.

enum ENTITY_ACTION {
	IDLE, WALKING #add more as needed
}

@export var facing_angle: int = 0
@export var current_action: ENTITY_ACTION = ENTITY_ACTION.IDLE

func _ready() -> void:
	%RotationCoordinator.rotate.connect(_on_rotate)
	pass

# Received from RotationCoordinator when player camera rotates a 45degree increment
func _on_rotate(angle:int) -> void:
	facing_angle = posmod(facing_angle + angle, 8)
	set_sprite_from_action()
	pass

func set_sprite_from_action() -> void:
	var anim_name: String = get_anim_name()
	if $AnimatedSprite3D.sprite_frames.has_animation(anim_name):
		$AnimatedSprite3D.play(anim_name)
	else:
		$AnimatedSprite3D.play(get_default_anim_name())
	pass
	
func get_anim_name() -> String:
	return str(current_action) + "_" + str(facing_angle)

func get_default_anim_name() -> String:
	return str(ENTITY_ACTION.IDLE) + "_" + str(facing_angle)

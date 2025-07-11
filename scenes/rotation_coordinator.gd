class_name RotationCoordinator extends Node

signal rotate(rotation: int)

func _on_player_camera_rotate(rotation: int) -> void:
	rotate.emit(rotation)

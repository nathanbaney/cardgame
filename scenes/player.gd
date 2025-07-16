extends RotatingEntity

var is_moving: bool = false
var raw_move_vector: Vector2i = Vector2i.ZERO
var move_vector: Vector2 = Vector2.ZERO
var move_speed: float = 5.0

var is_rotating: bool = false
var rotation_increment: float = PI / 8 # rads
var rotation_speed: float = 5.0
var old_rot: float = 0.0
var new_rot: float = 0.0
var sprite_rotation: int = 0

signal camera_rotate(rotation: int)

func _process(delta: float) -> void:
	if is_rotating:
		var current_rot: float = snappedf(lerp_angle(new_rot, old_rot, ease($RotationTimer.time_left / $RotationTimer.wait_time, 3.0)), PI / 256)
		var old_sprite_rot: int = to_sprite_rotation(self.rotation_degrees.y)
		var new_sprite_rot: int = to_sprite_rotation(rad_to_deg(current_rot))
		if old_sprite_rot != new_sprite_rot:
			print("diff ", new_sprite_rot - old_sprite_rot, " actual old/new ", self.rotation_degrees.y, " ", rad_to_deg(current_rot))
			camera_rotate.emit(new_sprite_rot - old_sprite_rot) 
		self.rotation.y = fposmod(current_rot, TAU)
	
	if is_moving:
		var movement_vector: Vector3 = get_movement_vector()
		movement_vector = movement_vector.rotated(Vector3.UP, move_to_angle())
		self.global_translate(movement_vector * move_speed * delta)
		self.facing_angle = get_facing_angle_for_movement()
		set_sprite_from_action()
			
	pass # move relative to local direction, not global

func _input(event: InputEvent) -> void:	
	if is_processing_movement(event):
		move_vector = Input.get_vector("left", "right", "down", "up")
	
	if event.is_action_pressed("cameraCW", true) and $RotationTimer.is_stopped():
		$RotationTimer.start()
		is_rotating = true
		sprite_rotation = 1
		old_rot = self.rotation.y
		new_rot = old_rot + rotation_increment
	elif event.is_action_pressed("cameraCCW", true) and $RotationTimer.is_stopped():
		$RotationTimer.start()
		is_rotating = true
		sprite_rotation = -1
		old_rot = self.rotation.y
		new_rot = old_rot - rotation_increment

func _on_rotation_timer_timeout() -> void:
	is_rotating = false

func get_movement_vector() -> Vector3:
	var cam_pos: Vector3 = $Camera3D.global_position
	# print("cam ", cam_pos, " self ", self.global_position)
	cam_pos.y = self.global_position.y
	var movement_vector: Vector3 = cam_pos.direction_to(self.global_position)
	#print(movement_vector)
	return movement_vector

func is_processing_movement(event: InputEvent) -> bool:
	if event.is_action_pressed("down", true):
		raw_move_vector.y = -1
	elif event.is_action_pressed("up", true):
		raw_move_vector.y = 1
	elif event.is_action_pressed("left", true):
		raw_move_vector.x = -1
	elif event.is_action_pressed("right", true):
		raw_move_vector.x = 1
	elif event.is_action_released("down") and raw_move_vector.y == -1:
		raw_move_vector.y = 0
	elif event.is_action_released("up") and raw_move_vector.y == 1:
		raw_move_vector.y = 0
	elif event.is_action_released("left") and raw_move_vector.x == -1:
		raw_move_vector.x = 0
	elif event.is_action_released("right") and raw_move_vector.x == 1:
		raw_move_vector.x = 0
		
	if raw_move_vector == Vector2i.ZERO:
		is_moving = false
	else:
		is_moving = true
	return is_moving

func move_to_angle() -> float:
	return move_vector.angle() - PI / 2

func get_facing_angle_for_movement() -> int:
	var floaty_angle: float = rad_to_deg(move_vector.angle()) + 1 #stoopid off-by-one
	var angle: int = (int(fposmod(floaty_angle, 360.0) / 45) % 8)
	return angle

func to_sprite_rotation(deg_rotation: float) -> int:
	return 7 - (int(fposmod(roundf(deg_rotation), 360.0) / 45) % 8)

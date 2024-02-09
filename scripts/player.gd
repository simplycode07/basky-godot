extends RigidBody2D

var mouse_pos = []
var radius = 16

func _process(delta):
	if Input.is_action_just_pressed("left_mouse_button") and len(mouse_pos) < 1:
		mouse_pos.append(DisplayServer.mouse_get_position())
		
	if Input.is_action_just_released("left_mouse_button") and len(mouse_pos):
		mouse_pos.append(DisplayServer.mouse_get_position())
		
		linear_velocity.x = (mouse_pos[0][0] - mouse_pos[1][0]) * 8
		linear_velocity.y = (mouse_pos[0][1] - mouse_pos[1][1]) * 8
		mouse_pos = []
		
	var collision_info = move_and_collide(linear_velocity * delta)
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		
		linear_velocity.x *= 0.6
		linear_velocity.y *= 0.6
		
		

	rotate(linear_velocity.x * delta / (PI * radius))

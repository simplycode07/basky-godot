extends RigidBody2D

var mouse_pos = []
var radius = 16
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var line_2d = %Line2D
@onready var sprite_2d = %Sprite2D

func draw_trajectory(current_mouse_pos, delta) -> void:
	line_2d.clear_points()
	var pos = Vector2.ZERO
	var vel = Vector2((mouse_pos[0][0]-current_mouse_pos[0]) * 8, (mouse_pos[0][1] - current_mouse_pos[1]) * 8)
	
	if mouse_pos[0] != current_mouse_pos:
		for i in range(50):
			vel.y += gravity * delta
			pos += vel * delta
			line_2d.add_point(pos)
	

func _process(delta):
	if Input.is_action_just_pressed("left_mouse_button") and len(mouse_pos) < 1:
		mouse_pos.append(DisplayServer.mouse_get_position())
		line_2d.clear_points()
		
	if Input.is_action_just_released("left_mouse_button") and len(mouse_pos):
		mouse_pos.append(DisplayServer.mouse_get_position())
		linear_velocity.x = (mouse_pos[0][0] - mouse_pos[1][0]) * 8
		linear_velocity.y = (mouse_pos[0][1] - mouse_pos[1][1]) * 8
		
		line_2d.clear_points()
		mouse_pos = []
		
	if len(mouse_pos):
		draw_trajectory(DisplayServer.mouse_get_position(), delta)
		
	var collision_info = move_and_collide(linear_velocity * delta)
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		
		linear_velocity.x *= 0.6
		linear_velocity.y *= 0.6
		
		
	sprite_2d.rotate(linear_velocity.x * delta / (PI * radius))

extends RigidBody2D

var mouse_pos = []
var radius = 16
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var counter = 0

@onready var line_2d = %Line2D
@onready var sprite_2d = %Sprite2D
@onready var bounce_particles = %BounceParticles

func draw_trajectory(current_mouse_pos, delta) -> void:
	line_2d.clear_points()
	var pos = Vector2.ZERO
	var vel = Vector2((mouse_pos[0][0]-current_mouse_pos[0]) * 8, (mouse_pos[0][1] - current_mouse_pos[1]) * 8)
	
	if mouse_pos[0] != current_mouse_pos:
		for i in range(300):
			vel.y += gravity * delta * gravity_scale
			pos += vel * delta
			line_2d.add_point(pos)
	

func _process(delta):
	#if linear_velocity < Vector2(40, 40):
		#linear_velocity = Vector2(0, 0)
	
	if Input.is_action_just_pressed("left_mouse_button") and len(mouse_pos) < 1:
		mouse_pos.append(DisplayServer.mouse_get_position())
		counter += 1
		print("mouse pressed" + str(counter))
		line_2d.clear_points()
		
	if Input.is_action_just_released("left_mouse_button") and len(mouse_pos):
		mouse_pos.append(DisplayServer.mouse_get_position())
		linear_velocity.x = (mouse_pos[0][0] - mouse_pos[1][0]) * 8
		linear_velocity.y = (mouse_pos[0][1] - mouse_pos[1][1]) * 8
		
		line_2d.clear_points()
		mouse_pos = []
	if Input.is_action_just_pressed("jump"):
		linear_velocity = Vector2(0, 0)
		   
	var collision_info = move_and_collide(linear_velocity * delta)
	if collision_info:
		print(linear_velocity)
		
		var normal = collision_info.get_normal()
		linear_velocity = linear_velocity.bounce(normal)
		if normal[0] == 0:
			#if linear_velocity.x > 0.1 else 0.0
			linear_velocity.x *= 0.9 
			linear_velocity.y *= 0.6
		else:
			linear_velocity.x *= 0.6
		
		# fix velocity not decreasing below (0, 37)
		# less than -60 because after bouncing on floor velocity becomes negative
		if linear_velocity.y < -60:
			bounce_particles.position = - normal * 40
			for particles in bounce_particles.get_children():
				particles.emitting = true

	if len(mouse_pos):
		Engine.time_scale = max(Engine.time_scale - 0.2, 0.2)
		draw_trajectory(DisplayServer.mouse_get_position(), delta)
		
	else:
		Engine.time_scale = min(Engine.time_scale + 0.3, 1)
	
	sprite_2d.rotate(linear_velocity.x * delta / (PI * radius))

extends CharacterBody2D


const max_velocity = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var acceleration = 10000

var mouse_pos = []

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	var collision_info = move_and_collide(velocity * delta)
	if collision_info and not Input.is_action_pressed("jump"):
		velocity = velocity.bounce(collision_info.get_normal())
		velocity.x *= 0.7
		velocity.y *= 0.7
		
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x += acceleration * delta * direction
		if not (velocity.x < max_velocity and velocity.x > -max_velocity):
			velocity.x = max_velocity * direction
		
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, 12)
	
	#if Input.CURSOR_DRAG()
	# debug statements
	if Input.is_action_just_pressed("left_mouse_button") and len(mouse_pos) < 1:
		mouse_pos.append(DisplayServer.mouse_get_position())
		print(mouse_pos)
		
	if Input.is_action_just_released("left_mouse_button") and len(mouse_pos):
		mouse_pos.append(DisplayServer.mouse_get_position())
		print(mouse_pos)
		
		velocity.x = (mouse_pos[0][0] - mouse_pos[1][0]) * 5
		velocity.y = (mouse_pos[0][1] - mouse_pos[1][1]) * 5
		
		print("clearning mouse_pos")
		mouse_pos = []
		
		
		
	
	rotate(velocity.x * delta / (PI * 16))
	move_and_slide()

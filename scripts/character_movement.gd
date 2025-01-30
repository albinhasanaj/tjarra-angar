extends CharacterBody3D

# Player nodes
@onready var head = $head2
@onready var standing_collision_shape: CollisionShape3D = $standing_collision_shape2
@onready var crouching_collision_shape: CollisionShape3D = $crouching_collision_shape2
@onready var ray_cast_3d: RayCast3D = $RayCast3D2

# Speed vars
var current_speed = 5.0
const walking_speed = 5.0
const sprinting_speed = 8.0
const crouching_speed = 3.0

# Movement vars
var crouching_depth =-0.3
const jump_velocity = 4.5
var lerp_speed = 10.0

# input vars
var direction = Vector3.ZERO
var mouse_sens = 0.15

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#Mouse looking logic
	if event is InputEventMouseMotion:
		mouse_sens = SettingsManager.mouse_sens
		rotate_y(deg_to_rad(-event.relative.x * 0.1 * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * 0.1 * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89),deg_to_rad(89))
		
		
		#make you able to esc to close game
#	if Input.is_action_just_pressed("quit"):
#		get_tree().quit()
		
	if Input.is_action_just_pressed("menu"):
		$IngameMenu.visible = not $IngameMenu.visible
	
func _physics_process(delta):
	# Handle movement state
	
	if $IngameMenu.visible:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#Crouching
	if Input.is_action_pressed("crouch"):
		
		current_speed = crouching_speed
		head.position.y = lerp(head.position.y,1.8 + crouching_depth,delta*lerp_speed)
		
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false
		
	elif !ray_cast_3d.is_colliding():
		
	# Standing logic
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true
		
		head.position.y = lerp(head.position.y,1.8,delta*lerp_speed)
		if Input.is_action_pressed("sprinting"):
	# Sprinting logic
			current_speed = sprinting_speed
		else:
	# Walking logic
			current_speed = walking_speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var world_direction = (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = lerp(direction, world_direction, delta * lerp_speed)

	if direction != Vector3.ZERO:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

		
	move_and_slide()


func _on_change_scene_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		#later change to phase 3 in the game --> then make dynamic
		get_tree().change_scene_to_file("res://scenes/Resecentrum/resecentrum_scene.tscn")
		

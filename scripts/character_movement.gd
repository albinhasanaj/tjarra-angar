extends CharacterBody3D

const PickUp = preload("res://item/pick_up/pick_up.tscn")


@export var inventory_data: InventoryData
@onready var interact_ray: RayCast3D = $head2/Camera3D/InteractRay

# Player nodes
@onready var head = $head2
@onready var standing_collision_shape: CollisionShape3D = $standing_collision_shape2
@onready var crouching_collision_shape: CollisionShape3D = $crouching_collision_shape2
@onready var ray_cast_3d: RayCast3D = $RayCast3D2
# Stamina vars
@onready var stamina = $head2/Camera3D/TextureProgressBar
var can_regen = false
var time_to_wait = 1.5
var s_timer = 0
var can_start_stimer = true


signal toggle_inventory

var health: int = 5

func _ready():
	PlayerManager. player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	stamina.value = stamina.max_value
	
	$UI/HotBarInventory.set_inventory_data(inventory_data)
#Stamina
func _process(delta):
	if can_regen == false && stamina.value != 100 or stamina.value == 0:
		can_start_stimer = true
		if can_start_stimer:
			s_timer += delta
			if s_timer >= time_to_wait:
				can_regen = true
				can_start_stimer = false
				s_timer = 0
	if stamina.value == 100:
		can_regen = false

	if can_regen == true:
		stamina.value += 0.5
		can_start_stimer = false
		s_timer = 0

# Speed vars
var current_speed = 5.0
const walking_speed = 5.0
const sprinting_speed = 8.0
const crouching_speed = 3.0

# Movement vars
var crouching_depth = -0.3
const jump_velocity = 4.5
var lerp_speed = 10.0

# Input vars
var direction = Vector3.ZERO
var mouse_sens = 0.15

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event: InputEvent) -> void:
	# Mouse looking logic
	if event is InputEventMouseMotion:
<<<<<<< HEAD
		mouse_sens = SettingsManager.mouse_sens
		rotate_y(deg_to_rad(-event.relative.x * 0.1 * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * 0.1 * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89),deg_to_rad(89))
		
		
		#make you able to esc to close game
#	if Input.is_action_just_pressed("quit"):
#		get_tree().quit()
		
	if Input.is_action_just_pressed("menu"):
		$IngameMenu.visible = not $IngameMenu.visible
=======
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	# Make you able to esc to close game
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
>>>>>>> 4fdc0cf7b446a7569b9307ccdeb4c01d5f53e87c
	
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory_interface()
		
	
<<<<<<< HEAD
	if $IngameMenu.visible:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#Crouching
=======
	if Input.is_action_just_pressed("interact"):
		interact()



func _physics_process(delta):
	

	# Handle movement state

	# Crouching
>>>>>>> 4fdc0cf7b446a7569b9307ccdeb4c01d5f53e87c
	if Input.is_action_pressed("crouch"):
		current_speed = crouching_speed
		head.position.y = lerp(head.position.y, 1.8 + crouching_depth, delta * lerp_speed)

		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false

	elif !ray_cast_3d.is_colliding():
		# Standing logic
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true

		head.position.y = lerp(head.position.y, 1.8, delta * lerp_speed)

		# Sprinting logic
		if Input.is_action_pressed("sprinting") and stamina.value > 0:  # Check if stamina is greater than 0
			stamina.value -= 1
			can_regen = false
			s_timer = 0
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
		# Later change to phase 3 in the game --> then make dynamic
		get_tree().change_scene_to_file("res://scenes/Resecentrum/resecentrum_scene.tscn")

	
func toggle_inventory_interface() -> void:
	print("inv received")
	var inventory_interface = $UI/InventoryInterface
	inventory_interface.set_player_inventory_data(inventory_data)
	inventory_interface.visible = not inventory_interface.visible
	
	var interface = $UI/InventoryInterface/ExternalInventory
	interface.visible = false
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
func toggle_external_inventory(external_owner):
	toggle_inventory_interface()
	
	var interface = $UI/InventoryInterface/ExternalInventory
	interface.visible = true
	var inventory_interface = $UI/InventoryInterface
	inventory_interface.set_external_inventory(external_owner)
	
	if interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		

func interact() -> void:
	if interact_ray.is_colliding():
		interact_ray.get_collider().player_interact()
		


func _on_inventory_interface_drop_slot_data(slot_data: SlotData) -> void:
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = position
	get_tree().root.add_child(pick_up)

func heal(heal_value: int) -> void:
	health += heal_value
	

extends RigidBody3D

func _physics_process(delta):

	look_at(global_position + linear_velocity)
func _ready():
	await(get_tree().create_timer(20).timeout)
	queue_free()

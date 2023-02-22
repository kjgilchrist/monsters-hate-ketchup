extends KinematicBody

# Emitted when the player defeats the monster.
signal defeated

# Minimum speed of the mob in meters per second.
export var min_speed = 5
# Maximum speed of the mob in meters per second.
export var max_speed = 5

var position = Vector3.ZERO
var velocity = Vector3.ZERO


func _physics_process(_delta):
	# warning-ignore:return_value_discarded
	move_and_slide(velocity)


func initialize(start_position, player_position):
	#show()
	#var direction_to_player = start_position - player_position
	look_at_from_position(start_position, player_position, Vector3.UP)
	#rotate_y(rand_range(-PI / 4, PI / 4))

	var random_speed = rand_range(min_speed, max_speed)
	# We calculate a forward velocity first, which represents the speed.
	velocity = Vector3.FORWARD * random_speed
	#velocity = direction_to_player.normalized() * random_speed
	# We then rotate the vector based on the mob's Y rotation to move in the direction it's looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)

	#$AnimationPlayer.playback_speed = random_speed / min_speed


func defeat():
	print("Mob Dead")
	emit_signal("defeated")
	queue_free()

func _on_VisibilityNotifier_camera_entered(camera):
	if camera.is_in_group("PlayerCamera"):
		print("Mob Spotted!")
#
func _on_VisibilityNotifier_camera_exited(camera):
	if camera.is_in_group("PlayerCamera"):
		print("Mob Removed!")
		queue_free()

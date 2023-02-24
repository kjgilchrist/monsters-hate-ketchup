extends KinematicBody

# Emitted when the player defeats the monster.
signal defeated
signal lost

# Minimum speed of the mob in meters per second.
export var min_speed = 15
# Maximum speed of the mob in meters per second.
export var max_speed = 25

# var position = Vector3.ZERO
var velocity = Vector3.ZERO
var camera_position = Vector3.ZERO
var distance_to_player: float = 0.00

func _physics_process(_delta):
	# Update distance_to_player.
	distance_to_player = translation.distance_to(camera_position)
	#print(distance_to_player)
	if distance_to_player < 7.5:
		velocity = Vector3.ZERO
	else:
		# warning-ignore:return_value_discarded
		move_and_slide(velocity)


func initialize(start_position, player_position):
#	# Set texture
#	var image = ("res://assets/2D/furry_c.png")
#	var s = Vector2.ZERO
#	s.x = 10
#	s.y = 10
#	get_node("Pivot/MeshInstance").set_texture(image)
#	get_node("Pivot/MeshInstance").scale = s
	
	# Because apparently we can't get this any other way.
	camera_position = player_position
	#var direction_to_player = start_position - player_position
	look_at_from_position(start_position, player_position, Vector3.UP)
	#rotate_y(rand_range(-PI / 4, PI / 4))
	distance_to_player = start_position.distance_to(player_position)
	#print(distance_to_player)
	
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


# Currently don't work.
func _on_VisibilityNotifier_camera_entered(camera):
	if camera.is_in_group("PlayerCamera"):
		print("Mob Spotted!")
#
func _on_VisibilityNotifier_camera_exited(camera):
	if camera.is_in_group("PlayerCamera"):
		print("Mob Removed!")
		queue_free()


# Additional Memory Leak protection.
func _on_DeathTimer_timeout():
	print("Mob Timed Out")
	emit_signal("lost")
	queue_free()

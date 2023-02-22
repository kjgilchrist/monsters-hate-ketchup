extends Spatial

export (String) var switch = "off"


func _ready():
	pass


func _process(_delta):
	if switch == "on":
		$OmniLight.show()
	else:
		$OmniLight.hide()


func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()
	print("Mob Instance Created")

	# Choose a random location on the SpawnPath.
	var mob_spawn_location = get_node("Room" + str(current_room_number) + "/SpawnPath/SpawnLocation")
	print(mob_spawn_location)
	mob_spawn_location.offset = randf()
	print("Spawn Location Found: Room" + str(current_room_number))

	# Communicate the spawn location and the player's location to the mob.
	var player_position = $PlayerNode/Camera.get_camera_transform().origin
	mob.initialize(mob_spawn_location.translation, player_position)
	print("Mob Initialized")

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	# We connect the mob to the score label to update the score upon squashing a mob.
	mob.connect("defeated", $HUD/Score, "_on_Mob_defeated")

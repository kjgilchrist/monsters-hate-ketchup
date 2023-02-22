extends Spatial

export (int) var room_number = 0 #Must be set for each instance
export (bool) var is_current = false
export (bool) var bs_active = false
export (Vector3) var room_adjustment = Vector3.ZERO
export var room_y_rotation = 0
export (String) var switch = "off"
export(PackedScene) var mob_scene = load("res://instances/mob.tscn")

func _ready():
	pass


func _process(_delta):
	#print(str(room_number) + ": " + str(is_current))
	#print("Room" + str(room_number) + ": " + str(room_adjustment))
	# Turn on/off light in room.
	if switch == "on":
		$OmniLight.show()
		bs_active = true
	else:
		$OmniLight.hide()
		bs_active = false


func _on_MobTimer_timeout():
	if is_current == true:
		# Create a new instance of the Mob scene.
		var mob = mob_scene.instance()
		print("Mob Instance Created")

		# Choose a random location on the SpawnPath.
		var mob_spawn_location = $SpawnPath/SpawnLocation
		#print(mob_spawn_location.translation)
		mob_spawn_location.unit_offset = randf()
		print("Spawn Location Found: Room" + str(room_number))

		# Communicate the spawn location and the player's location to the mob.
		var player_position = $Camera.get_camera_transform().origin
		#print(player_position)
		var mob_spawn_adjusted = mob_spawn_location.translation.rotated(Vector3(0,1,0),room_y_rotation) + room_adjustment
		#print(mob_spawn_adjusted)
		mob.initialize(mob_spawn_adjusted, player_position)
		print("Mob Initialized")

		# Spawn the mob by adding it to the Main scene.
		add_child(mob)
		# We connect the mob to the score label to update the score upon squashing a mob.
		mob.connect("defeated", $"../HUD/Score", "_on_Mob_defeated")

extends Spatial

onready var light_node = get_node("Room1")  # The path in the tree, not the file system.
onready var start_camera = get_node("Room1/Camera")
var current_room_number = 1
var current_room_node

export(PackedScene) var mob_scene = load("res://instances/mob.tscn")

func _unhandled_input(_event):
#	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
#		# warning-ignore:return_value_discarded
#		get_tree().reload_current_scene()
	pass


func _ready():
	randomize();
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	$PlayerNode.transform = start_camera.get_camera_transform()
	for n in range (1,get_tree().get_nodes_in_group("Rooms").size()+1):
		get_node("Room" + str(n)).room_adjustment = get_node("Room" + str(n)).translation
		get_node("Room" + str(n)).room_y_rotation = get_node("Room" + str(n)).get_rotation().y
	current_room_node = light_node
	$HUD/Clock.hide()
	$HUD/Score.hide()


func _process(_delta):
	$PlayerNode/SpotLight.look_at(PointToRay($PlayerNode/Camera, $HUD/Toaster), Vector3.UP)


func _input(event):
	# Change Camera keys
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_1:
			print("Switched to Camera 1")
			ChangeCurrentCamera(1)
		if event.scancode == KEY_2:
			print("Switched to Camera 2")
			ChangeCurrentCamera(2)
		if event.scancode == KEY_3:
			print("Switched to Camera 3")
			ChangeCurrentCamera(3)
		if event.scancode == KEY_4:
			print("Switched to Camera 4")
			ChangeCurrentCamera(4)
		if event.scancode == KEY_5:
			print("Switched to Camera 5")
			ChangeCurrentCamera(5)
		if event.scancode == KEY_6:
			print("Switched to Camera 6")
			ChangeCurrentCamera(6)
	# Switch Room light on and off in-game
	if Input.is_action_pressed("test_toggle"):
		SwitchCurrentRoomLight()
	# If currently constrained to window and non-visible.
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED or Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED:
		# Hit ESC to exit window.
		if event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		# If player is actively moving mouse in game window.
		#if event is InputEventMouseMotion:
	if event.is_action_pressed("click"):
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	#get_tree().set_input_as_handled()


func PointToRay(o_camera, end_point):
	var spaceState = get_world().direct_space_state
	var toastPos = end_point.get_position() #$HUD/Toaster
	#var mousePos = get_viewport().get_mouse_position()
	var camera = o_camera #$PlayerNode/Camera
	var rayOrigin = camera.project_ray_origin(toastPos)
	var rayEnd = rayOrigin + camera.project_ray_normal(toastPos) * 2000
	var rayArray = spaceState.intersect_ray(rayOrigin, rayEnd)
	if rayArray:
		return rayEnd
	print("Error: Dictionary empty")
	return Vector3()


func ChangeCurrentCamera(x):
	current_room_number = x
	current_room_node.is_current = false
	current_room_node = get_node("Room" + str(x))
	print(current_room_node)
	current_room_node.is_current = true
	var new_camera = get_node("Room" + str(x) + "/Camera")
	$PlayerNode.transform = new_camera.get_camera_transform()


func SwitchCurrentRoomLight():
	var current_light = get_node("Room" + str(current_room_number))
	if current_light.switch == "on":
		current_light.switch = "off"
	else:
		current_light.switch = "on"


func _on_MobTimer_timeout():
	$MobTimer.wait_time = rand_range(5,15)
	if get_tree().get_nodes_in_group("Mobs").size() < 1:
		# Create a new instance of the Mob scene.
		var mob = mob_scene.instance()
		print("Mob Instance Created")

		# Choose a random location on the SpawnPath.
		var mob_spawn_location = get_node("Room" + str(current_room_number) + "/SpawnPath/SpawnLocation")
		#print(mob_spawn_location.translation)
		mob_spawn_location.unit_offset = randf()
		print("Spawn Location Found: Room" + str(current_room_number))

		# Communicate the spawn location and the player's location to the mob.
		var player_position = $PlayerNode/Camera.get_camera_transform().origin
		#print(player_position)
		var mob_spawn_adjusted = mob_spawn_location.translation.rotated(Vector3(0,1,0), get_node("Room" + str(current_room_number)).room_y_rotation) + get_node("Room" + str(current_room_number)).room_adjustment
		#print(mob_spawn_adjusted)
		mob.initialize(mob_spawn_adjusted, player_position)
		print("Mob Initialized")

		# Spawn the mob by adding it to the Main scene.
		add_child(mob)
		# Connect signals.
		mob.connect("defeated", $HUD/Score, "_on_Mob_defeated")
		mob.connect("lost", self, "_on_Mob_lost")
	else:
		print("A Mob already exists in this room.")


func _on_HUD_change_ccw():
	if $HUD/Ketchup.port_left == true and $HUD/Toaster.port_left == true:
		var camera_change = (current_room_number + 4) % (get_tree().get_nodes_in_group("Rooms").size()) + 1
		ChangeCurrentCamera(camera_change)


func _on_HUD_change_cw():
	if $HUD/Ketchup.port_right == true and $HUD/Toaster.port_right == true:
		var camera_change = (current_room_number) % (get_tree().get_nodes_in_group("Rooms").size()) + 1
		ChangeCurrentCamera(camera_change)


func _on_Mob_lost():
	$MobTimer.stop()
	$HUD/Clock.hide()
	$HUD/Score.hide()
	$TitleScreen.show()


func _on_TitleScreen_start():
	$MobTimer.start()
	$HUD/Clock.show()
	$HUD/Score.show()

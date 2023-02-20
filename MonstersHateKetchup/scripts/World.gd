extends Spatial

onready var light_node = get_node("Room1")  # The path in the tree, not the file system.
onready var start_camera = get_node("Room1/Camera")
var current_camera = start_camera
var current_room_number = 1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	$PlayerNode.transform = start_camera.get_camera_transform()

func _process(_delta):
	$PlayerNode/SpotLight.look_at(ScreenPointToRay(), Vector3.UP)

func _input(event):
	# Change Camera keys
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_1:
			ChangeCurrentCamera(1)
			print("Switched to Camera 1")
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
	get_tree().set_input_as_handled()

func ScreenPointToRay():
	var spaceState = get_world().direct_space_state
	var toastPos = $HUD/Toaster.get_position()
	#var mousePos = get_viewport().get_mouse_position()
	var camera = $PlayerNode/Camera
	var rayOrigin = camera.project_ray_origin(toastPos)
	var rayEnd = rayOrigin + camera.project_ray_normal(toastPos) * 2000
	var rayArray = spaceState.intersect_ray(rayOrigin, rayEnd)
	if rayArray:
		return rayEnd
	print("Error: Dictionary empty")
	return Vector3()

func ChangeCurrentCamera(x):
	current_room_number = x
	var new_camera = get_node("Room" + str(x) + "/Camera")
	$PlayerNode.transform = new_camera.get_camera_transform()

func SwitchCurrentRoomLight():
	var current_light = get_node("Room" + str(current_room_number))
	if current_light.switch == "on":
		current_light.switch = "off"
	else:
		current_light.switch = "on"

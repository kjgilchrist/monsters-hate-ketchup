extends Spatial

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _process(_delta):
	pass

func _input(event):
	# If currently constrained to window and non-visible.
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED or Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED:
		# Hit ESC to exit window.
		if event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		# Player is within window and moving mouse.
		if event is InputEventMouseMotion:
			$SpotLight.look_at(ScreenPointToRay(), Vector3.UP)
	if event.is_action_pressed("click"):
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	get_tree().set_input_as_handled()

func ScreenPointToRay():
	var spaceState = get_world().direct_space_state
	var mousePos = get_viewport().get_mouse_position()
	var camera = $CameraNode/Camera
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 2000
	var rayArray = spaceState.intersect_ray(rayOrigin, rayEnd)
	if rayArray:
		return rayEnd
	print("Error: Dictionary empty")
	return Vector3()

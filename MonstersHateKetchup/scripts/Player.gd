extends KinematicBody2D

# Defaults will not work correctly, must be changed manually per instance.
export var move_right = "ui_right"
export var move_left = "ui_left"
export var move_up = "ui_up"
export var move_down = "ui_down"
export var action_key = "ui_accept"

export var speed = 300
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2.ZERO # Player's movement vector.
	if Input.is_action_pressed(move_right):
		velocity.x += 1
	if Input.is_action_pressed(move_left):
		velocity.x -= 1
	if Input.is_action_pressed(move_up):
		velocity.y -= 1
	if Input.is_action_pressed(move_down):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
#		$AnimatedSprite.play()
#	else:
#		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
#	if velocity.x != 0:
#		$AnimatedSprite.animation = "walk"
#		$AnimatedSprite.flip_v = false
#		$AnimatedSprite.flip_h = velocity.x < 0 # Boolean assignment
#	elif velocity.y != 0:
#		$AnimatedSprite.animation = "up"
#		$AnimatedSprite.flip_v = velocity.y > 0
	
	if Input.is_action_pressed(action_key):
		var rayCheck = PointToRay(get_node("../../PlayerNode/Camera"), self)
		if rayCheck:
			var rayCollide = rayCheck.collider
			if rayCollide.is_in_group("Mobs"):
				var nodeName = rayCollide.to_string()
				get_node("../../" + nodeName).defeat()


func PointToRay(o_camera, end_point):
	var spaceState = get_parent().get_parent().get_world().direct_space_state
	var playerPos = end_point.get_position()
	var rayOrigin = o_camera.project_ray_origin(playerPos)
	var rayEnd = rayOrigin + o_camera.project_ray_normal(playerPos) * 2000
	var rayArray = spaceState.intersect_ray(rayOrigin, rayEnd, [self], 0b00000000000000000100)
	if rayArray:
		return rayArray
	print("Error: Dictionary empty, no collision detected.")
	return Vector3()

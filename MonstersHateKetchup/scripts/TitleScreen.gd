extends Control


signal start


func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	pass


func _process(_delta):
	pass


#func _input(event):
#	# If currently constrained to window and non-visible.
#	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED or Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED:
#		# Hit ESC to exit window.
#		if event.is_action_pressed("ui_cancel"):
#			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#		# If player is actively moving mouse in game window.
#		#if event is InputEventMouseMotion:
#	if event.is_action_pressed("click"):
#			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
#				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func _on_StartButtonTemp_pressed():
	#Global.goto_scene("res://scenes/World.tscn")
	emit_signal("start")
	self.hide()

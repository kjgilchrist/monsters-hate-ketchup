tool

extends Area2D


export(String, FILE) var next_scene_path = ""


func _get_configuration_warning() -> String:
	if next_scene_path == "":
		return "Error: Portal Path not set"
	else:
		return ""


func _on_Portal_body_entered(body):
	if get_tree().change_scene(next_scene_path) != OK:
		print("Error: Unavailable Scene")

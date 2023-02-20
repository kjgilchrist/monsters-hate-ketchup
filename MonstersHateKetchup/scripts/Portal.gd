extends Area2D # Must extend HUD root node.


export var dir = ""


func _on_Portal_body_entered(body):
	if dir == "":
		print("Error: Direction not set.")
	else:
		emit_signal(dir)

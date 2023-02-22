extends Node2D # Must extend HUD root node.

# "cw" or "ccw" - clockwise, counterclockwise
signal change_cw
signal change_ccw


func _on_PortalLeft_body_entered(_body):
	emit_signal("change_ccw")


func _on_PortalRight_body_entered(_body):
	emit_signal("change_cw")

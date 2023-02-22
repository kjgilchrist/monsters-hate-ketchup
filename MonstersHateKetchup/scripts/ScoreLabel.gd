extends Label

var score = 0


func _ready():
	pass


func _on_Mob_defeated():
	score += 1
	text = "Score: %s" % score

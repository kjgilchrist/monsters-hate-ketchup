extends Spatial

export (int) var room_number = 0 #Must be manually set for each instance
export (bool) var is_current = false
export (bool) var bs_active = false
export (Vector3) var room_adjustment = Vector3.ZERO
export var room_y_rotation = 0
export (String) var switch = "off"
#export(PackedScene) var mob_scene = load("res://instances/mob.tscn")

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

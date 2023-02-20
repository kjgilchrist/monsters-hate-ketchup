extends Spatial

export (String) var switch = "off"

func _ready():
	pass

func _process(_delta):
	if switch == "on":
		$OmniLight.show()
	else:
		$OmniLight.hide()

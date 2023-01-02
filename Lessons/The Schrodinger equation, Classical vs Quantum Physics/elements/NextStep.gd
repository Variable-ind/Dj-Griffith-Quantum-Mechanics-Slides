extends Sprite

var flash_sec = 0.2

func _ready():
	frame = 0


func next_step():
	var tween = $Tween
	tween.interpolate_property(get_child(0),"color", Color("00e9e9e9"),Color("e9e9e9"),flash_sec)
	tween.start()
	yield(get_tree().create_timer(flash_sec), "timeout")
	if name == "Rough" && !texture:
		texture = preload("res://assets/graphics/Rough.png")
	else:
		frame += 1
	tween.interpolate_property(get_child(0),"color",Color("e9e9e9"), Color("00e9e9e9"),flash_sec)
	tween.start()

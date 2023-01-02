extends ColorRect

export var other = false

func _ready():
	if other:
		close_curtain()
		$Label.text = str("System : ", get_index() + 1)


func close_curtain():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"color",Color(1, 0.462745, 0.462745, 1),1)


func lift_curtain(value):
	var inside = false
	$ColorRect.visible = true
	$Sample.value = value
	var tween = get_tree().create_tween()
	tween.tween_property(self,"color",Color(1, 0.462745, 0.462745, 0),1)

	if value <= 250 && value >= 130:
		inside = true

	return inside

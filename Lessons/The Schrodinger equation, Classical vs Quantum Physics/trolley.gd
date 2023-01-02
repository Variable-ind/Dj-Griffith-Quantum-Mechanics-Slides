extends ColorRect

enum StepType { PAGE, ROUGH, EQUATIONS }

onready var ball = $ball
var time = 0

onready var page = $Page
onready var rough = $Rough
onready var equations = $Equations

# procedure for which steps should be revealed
var steps = [
	StepType.PAGE,
	 StepType.PAGE,
	 StepType.PAGE,
	 StepType.ROUGH,
	 StepType.PAGE,
	 StepType.ROUGH,
	 StepType.EQUATIONS,
	 StepType.ROUGH,
	 StepType.EQUATIONS
	]

var current_step = 0


func _ready():
	get_tree().paused = true


func _process(delta):
	ball.linear_velocity = Vector2(5000 * delta, 0)
	$HSlider.value = ball.transform.origin.x
	if time >= 5:
		get_tree().paused = true
	$Time.text = str("Time Elapsed T = ", int(time), " Seconds")
	time += delta


func _on_Start_pressed():
	get_tree().paused = false
	$Expected.visible = true


func _on_NextStep_pressed():
	if current_step < steps.size():
		match steps[current_step]:
			StepType.PAGE:
				page.next_step()
			StepType.ROUGH:
				rough.next_step()
			StepType.EQUATIONS:
				equations.next_step()
		current_step += 1


func _on_NextSlide_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://FreeParticle.tscn")

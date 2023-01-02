extends Control

var idx = 0

var last_draw_time = 1000000000000
var time_wait = 0.2

# Constant Parameters
const a = 10
const mass = 9.11 * pow(10,-31)
const h_cut :float = (6.626 / (2.0 * PI)) * pow(10,-34)
var t = 5 * 5000
var x_range = 5    # bounds of x axis
var x_step = 0.1

# Integral approximations
var approximation = 10  # how many waves taken
var approx_step = 0.5 # How close are waves

# Graph valus
var g_scale = 140  # scaling of graph

# Plotting Animation
var points := PoolVector2Array()
var start = false
var point_time = 0.01
var current_point = 0

# Measurement Variables
var measurements = []
var inside_counter = 0
var outside_counter = 0

signal experiment_finished


func _ready():
	randomize()
	connect("experiment_finished", self, "display_results")


func display_results():
	$RichTextLabel.text = str("Times Inside = ", inside_counter, "\n Times Outside = ", outside_counter)


func _process(delta):
	if points.size() > 0:
		if current_point < points.size():
			if last_draw_time > point_time:
				$Graph/Line2D.add_point(points[current_point])
				last_draw_time = 0
				current_point += 1
			last_draw_time += delta
	if start:
		$Cover.visible = false
		if last_draw_time > time_wait:
			if idx < $Ensemble.get_child_count():
				last_draw_time = 0
				var rnd_i = randi() % 325
				$curtain/Sample.value = measurements[rnd_i]
				var is_in = $Ensemble.get_child(idx).lift_curtain(measurements[rnd_i])
				if is_in:
					inside_counter += 1
				else:
					outside_counter += 1
				idx += 1
				if idx == $Ensemble.get_child_count():
					emit_signal("experiment_finished")
		last_draw_time += delta


func find_psi():
	var out = []
	var k = -approximation
	while k < approximation:
		var i = 0
		var x = -x_range
		while x < x_range:
			var e_num = Complex.new(0, (k * x - (h_cut * k * t)/(2 * mass)))

			var psi_k = (e_num.exp()).mul(Complex.new(1/(PI * sqrt(2)), 0))

			if k == -approximation:
				out.append(Vector2.ZERO)
			else:
				var val = (-psi_k.real * psi_k.real)
				out[i] += Vector2(0, val)
				out[i].x = x
			x += x_step
			i += 1
		k += approx_step
	return out


func _on_Button_pressed():
	$Graph/Line2D.clear_points()
	points = []
	for point in find_psi():
		if point.x * g_scale > 0 && point.x * g_scale < 325:
			points.append(point * g_scale)
			for _dups in range(0, -int(point.y * g_scale)):
				measurements.append(point.x * g_scale)
	measurements.shuffle()


func _on_CloseCurtain_toggled(button_pressed):
	if button_pressed:
		$CloseCurtain.text = "Lift Curtain"
		$curtain.close_curtain()
	else:
		start = true
		$CloseCurtain.text = "Close Curtain"
		var i = randi() % 325
		$curtain.lift_curtain(measurements[i])


func _on_Button2_pressed():
	get_tree().reload_current_scene()


func _on_Next_pressed():
	get_tree().change_scene("res://Schrodinger.tscn")

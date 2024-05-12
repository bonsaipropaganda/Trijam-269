extends Node3D

var charging
var box_scene = preload("res://box.tscn")
var game_started = false
@onready var progress_bar = $Control/ProgressBar
var time = 0
var tries = 0


# Called when the node enters the scene tree for the first time.
func _process(delta):
	if game_started:
		# charging up
		if Input.is_action_just_pressed("charge"):
			charging = true
		
		if Input.is_action_just_released("charge"):
			release_charge()

			
		if Input.is_action_just_pressed("reset"):
			reset()

		
		if charging:
			progress_bar.value += 1
		

func release_charge():
	charging = false
	shoot()
	progress_bar.value = 0

func reset():
	for child in get_children():
		if child.is_in_group("box"):
			child.queue_free()

func shoot():
	tries += 1
	$AudioStreamPlayer2.play()
	$Control/ModulateHbox/Tries.text = str(tries)
	var b = box_scene.instantiate()
	add_child(b)
	b.win.connect(_on_win)
	b.global_position = $Camera3D.global_position
	b.apply_central_impulse(Vector3(0,5,-(progress_bar.value/10)))

func _on_win():
	$AnimationPlayer.play("win")
	$WinLabel.text = "You won in " + str(time) + " seconds and " + str(tries) + " tries."
	game_started = false
	$GameTimer.stop()

func _on_start_button_pressed():
	reset()
	$Control/ProgressBar.value = 0
	charging = false
	
	$click.play()
	$AnimationPlayer.play("start")
	$GameTimer.start()
	time = 0
	tries = 0
	$Control/ModulateHbox/Timer.text = str(time)
	$Control/ModulateHbox/Tries.text = str(tries)
	game_started = true
	$Control/StartButton.focus_mode = 0 # no focus


func _on_area_3d_body_entered(body):
	if body.is_in_group("box"):
		body.quick_delete()
		print("quick delete")


func _on_game_timer_timeout():
	time += 1
	$Control/ModulateHbox/Timer.text = str(time)

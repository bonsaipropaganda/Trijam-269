extends RigidBody3D

signal win

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_timer_timeout():
	queue_free()


func _on_timer_2_timeout():
	queue_free()

func quick_delete():
	$Timer2.start()


func _on_area_3d_body_entered(body):
	if body.is_in_group("bulb"):
		await get_tree().create_timer(1).timeout
		if $Area3D.get_overlapping_bodies().size() > 0:
			win.emit()


func _on_body_entered(body):
	$Thud.play()

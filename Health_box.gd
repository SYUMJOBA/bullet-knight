extends Sprite



func _on_Area2D_area_entered(area):
	if area.name == "Player":
		queue_free()

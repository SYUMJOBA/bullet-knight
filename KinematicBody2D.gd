extends KinematicBody2D

var player
var playerfound = false

func _ready():
	pass

func _physics_process(delta):
	$RayHinge.rotation += delta*20
	if playerfound:
		look_at(player.global_position)
		move_and_slide(Vector2.RIGHT.rotated(rotation)*delta*6000)
	else:
		if $RayHinge/RayCast2D.is_colliding() and $RayHinge/RayCast2D.get_collider().name == "Player":
			player = $RayHinge/RayCast2D.get_collider()
			playerfound = true
			$AnimatedSprite.play("profile")
			$AnimatedSprite.flip_h = true
		if $RayHinge/RayCast2D4.is_colliding() and $RayHinge/RayCast2D4.get_collider().name == "Player":
			player = $RayHinge/RayCast2D4.get_collider()
			playerfound = true
			$AnimatedSprite.play("profile")
			$AnimatedSprite.flip_h = true
		if $RayHinge/RayCast2D2.is_colliding() and $RayHinge/RayCast2D2.get_collider().name == "Player":
			player = $RayHinge/RayCast2D2.get_collider()
			playerfound = true
			$AnimatedSprite.play("profile")
			$AnimatedSprite.flip_h = true
		if $RayHinge/RayCast2D3.is_colliding() and $RayHinge/RayCast2D3.get_collider().name == "Player":
			player = $RayHinge/RayCast2D3.get_collider()
			playerfound = true
			$AnimatedSprite.play("profile")
			$AnimatedSprite.flip_h = true
	
func _on_Blink_timeout():
	$AnimatedSprite.frame = 0


func _on_Enemy_area_entered(area):
	if area.name == "Bullet":
		queue_free()

extends Sprite

export var speed : int
var motion

func _ready():
	motion = Vector2.RIGHT.rotated(rotation)*speed*100

func _physics_process(delta):
	position += motion*delta
	


func _on_KillSwitch_timeout():
	queue_free()


func _on_Area2D_area_entered(area):
	queue_free()


func _on_Bullet_body_entered(body):
	queue_free()

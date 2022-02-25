extends KinematicBody2D

signal updateAmmo(amount)
signal incrementCoins(amount)
signal updateHealth(amount)
export var speed : int
var coins = 0
var canshoot = true
var bullet = preload("res://Bullet.tscn")
var rounds_in_inventory = 7
var health = 100

func _ready():
	emit_signal("incrementCoins", coins)
	emit_signal("updateAmmo", rounds_in_inventory)
	emit_signal("updateHealth", health)

var gunPos = position.x + 8
func _physics_process(delta):
	var motion = Vector2(0, 0)
	if Input.is_action_pressed("ui_right"):
		motion.x += 1
	if Input.is_action_pressed("ui_left"):
		motion.x -= 1
	if Input.is_action_pressed("ui_up"):
		motion.y -= 1
	if Input.is_action_pressed("ui_down"):
		motion.y += 1
	
	if Input.is_action_pressed("ui_right_click"):
		motion = Vector2(0, 0)
		motion = get_global_mouse_position() - position
	
	if motion != Vector2(0, 0):
		$Body.play("walking")
	else:
		$Body.play("standing")
	
	$Gun.look_at(get_global_mouse_position()+Vector2.DOWN.rotated(rotation)*3)
	
	var hasToFlip = get_global_mouse_position().x < position.x
	$Head.flip_h = hasToFlip
	$Body.flip_h = hasToFlip
	$Gun.flip_v = hasToFlip
	$Gun/Hand.flip_v = hasToFlip
	
	$Gun.position.x = gunPos - 16*int(hasToFlip)
	
	
	move_and_slide(motion.normalized()*delta*speed*100)
	
	if Input.is_action_just_pressed("ui_left_click"):
		if canshoot and rounds_in_inventory>0:
			rounds_in_inventory -= 1
			emit_signal("updateAmmo", rounds_in_inventory)
			$Gun.frame = 0
			$ShootSound.play()
			var bullet_instance = bullet.instance()
			bullet_instance.position = position+$Gun.position+Vector2.RIGHT.rotated($Gun.rotation)*10+Vector2.UP*2
			bullet_instance.look_at(get_global_mouse_position()+Vector2.DOWN.rotated(rotation)*3)
			bullet_instance.speed = 2
			get_tree().get_root().call_deferred("add_child", bullet_instance)
			canshoot = false
			$shoot_cooldown.start()
		elif canshoot and rounds_in_inventory == 0:
			$EmptyGunsound.play()

func _on_Player_area_entered(area):
	if area.name == "Coin":
		$Sound.play()
		area.get_parent().queue_free()
		coins += 1
		emit_signal("incrementCoins", coins)
	elif area.name == "Basic_bullets":
		area.get_parent().queue_free()
		rounds_in_inventory += 7
		emit_signal("updateAmmo", rounds_in_inventory)
		$ReloadSound.play()
	if area.name == "Eye_enemy":
		$EyeDamageCooldown.start()
		health -= 10
		emit_signal("updateHealth", health)
		$PlayerHitSound.play()
	if area.name == "Health_box":
		health += 30
		emit_signal("updateHealth", health)
		$HealthPickUp.play()


func _on_shoot_cooldown_timeout():
	canshoot = true

func _on_Player_area_exited(area):
	if area.name == "Eye_enemy":
		$EyeDamageCooldown.stop()

func _on_EyeDamageCooldown_timeout():
	health -= 10
	emit_signal("updateHealth", health)
	$PlayerHitSound.play()

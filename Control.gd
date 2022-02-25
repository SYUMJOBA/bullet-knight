extends Control



func _ready():
	pass # Replace with function body.


func _on_Player_incrementCoins(amount):
	$CoinLable.text = "Coins: " + str(amount)



func _on_Player_updateAmmo(amount):
	$AmmoLabel.text = "Ammo: " + str(amount)


func _on_Player_updateHealth(amount):
	$HealthBar.value = amount

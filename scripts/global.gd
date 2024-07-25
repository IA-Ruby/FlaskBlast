extends Node

var inventory = []

signal inventory_updated

var player_node: Node = null

func _ready():
	inventory.resize(15)

func add_potion(potion):
	for i in inventory:
		print(i)
		if inventory[i] == null:
			inventory[i] = potion
			inventory_updated.emit()
			return true
	return false
	
func remove_potion():
	inventory_updated.emit()

func set_player_reference(player):
	player_node = player

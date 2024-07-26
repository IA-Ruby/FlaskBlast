extends Node

@onready var inventory_slot_scene = preload("res://scenes/inventory_slot.tscn") 

var inventory = []

signal inventory_updated

var player_node: Node = null

func _ready():
	inventory.resize(15)

func add_potion(potion, slot):	
	inventory[slot] = potion
	inventory_updated.emit()
		
func remove_potion(slot):
	if(inventory[slot] != null):
		if inventory[slot].amount > 1:
			inventory[slot].amount -= 1
		else:
			inventory[slot] = null
		inventory_updated.emit()

func set_player_reference(player):
	player_node = player

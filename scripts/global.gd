extends Node

var inventory = []
@onready var inventory_slot_scene = preload("res://scenes/inventory_slot.tscn") 
signal inventory_updated

var player_node: Node = null
var hotbar_inventory = []
var inventory_row = 0
var item_amount = 0
var potion_to_swap = null
var player_light = false
var active_slot = 0
var crafting = false
var craft_index = null
var interact_nearby = false

func _ready():
	inventory.resize(15)
	hotbar_inventory.resize(5)
	fill_hotbar_row()

func slot_swap(potion_index):
	if potion_to_swap:
		var aux = inventory[potion_to_swap]
		inventory[potion_to_swap] = inventory[potion_index]
		inventory[potion_index] = aux
		potion_to_swap = null
		inventory_updated.emit()
	else:
		potion_to_swap = potion_index

func add_potion(potion : Potion):
	inventory[craft_index] = potion
	inventory_updated.emit()
	item_amount += 1
	print(item_amount)
		
func get_potion():
	return inventory[active_slot+(inventory_row*5)]
	
func remove_potion(slot):
	if(inventory[slot] != null):
		if inventory[slot].potion_amount > 1:
			inventory[slot].potion_amount -= 1
		else:
			inventory[slot] = null
			item_amount -= 1
	inventory_updated.emit()

func set_player_reference(player):
	player_node = player
	
func add_hotbar_potion(potion,slot):
	hotbar_inventory[slot] = potion

func change_inventory_row():
	inventory_row += 1
	if inventory_row > 2: 
		inventory_row = 0
	fill_hotbar_row()

func fill_hotbar_row():
	var a = inventory_row * 5
	var hotbar_slot = 0

	for i in range(a,(a+5)):
		add_hotbar_potion(inventory[i],hotbar_slot)
		hotbar_slot += 1
	inventory_updated.emit()
		
func open_craft(index):
	craft_index = index
	crafting = true

func close_craft():
	craft_index = null
	crafting = false

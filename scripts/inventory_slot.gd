extends Control

@onready var slot = $Slot
@onready var sprite = $PotionSprite
@onready var amount = $Amount
@onready var type = $Description/Type
@onready var area = $Description/Area
@onready var effect = $Description/Effect
@onready var potion_name = $Description/Name
@onready var description = $Description
@onready var options = $Options
@onready var craft = $Options/Craft
@onready var delete = $Options/Delete
@onready var swap = $Options/Swap
@onready var item_button = $ItemButton

var potion = null
var slot_index = -1
var swap_toggle = false

func _process(_delta):
	if slot_index == Global.active_slot:
		slot.frame = 1
	if swap_toggle:
		if potion:
			slot.frame = 1
		else:
			slot.frame = 4

func set_slot_index(new_index):
	slot_index = new_index

func set_empty():
	sprite.visible = false
	amount.text = ""
	slot.frame = 3

func set_potion(new_potion):
	potion = new_potion
	potion_name = new_potion["name"]
	sprite.frame = new_potion["size"]
	sprite.material.set_shader_parameter("new_color", new_potion["color"])
	amount.text = str(new_potion["amount"])
	type.frame = new_potion["type"]
	area.frame = new_potion["area"]
	effect.frame = new_potion["effect"]	

func _on_item_button_pressed():
	if slot_index < 0:
		if Global.potion_to_swap:
			Global.slot_swap(get_index())
		else:
			options.visible = !options.visible
			description.visible = false
	
func _on_item_button_mouse_entered():
		if potion:
			slot.frame = 1
			if slot_index < 0:
				description.visible = true
		else:
			slot.frame = 4
	
func _on_item_button_mouse_exited():
	if potion != null:
		slot.frame = 0
	else:
		slot.frame = 3
	description.visible = false
	
func _on_craft_button_button_down():
	craft.frame = 6

func _on_craft_button_pressed():
	var new_potion = {
		"amount" : randi_range(1,3),
		"name": "Ultimate Test",
		"color": Color.from_hsv(randf_range(0.0 ,1.0),1.0,1.0,1.0),
		"size": randi_range(0,11),
		"type": randi_range(0,1),
		"area": randi_range(5,7),
		"effect": randi_range(10,18),
	}
	Global.add_potion(new_potion,get_index())

func _on_craft_button_mouse_entered():
	craft.frame = 3

func _on_craft_button_mouse_exited():
	craft.frame = 0

func _on_del_button_button_down():
	delete.frame = 7
	
func _on_del_button_pressed():
	delete.frame = 1
	Global.remove_potion(get_index())

func _on_del_button_mouse_entered():
	delete.frame = 4

func _on_del_button_mouse_exited():
	delete.frame = 1
	
func _on_swap_button_button_down():
	swap.frame = 8

func _on_swap_button_pressed():
	if Global.potion_to_swap:
			Global.slot_swap(get_index())
	else:
		Global.potion_to_swap = get_index()
		swap_toggle = !swap_toggle
		if swap_toggle:
			swap.frame = 8
		else: 
			swap.frame = 5

func _on_swap_button_mouse_entered():
	if swap_toggle:
		swap.frame = 8
	else:
		swap.frame = 5

func _on_swap_button_mouse_exited():
	if swap_toggle:
		swap.frame = 8
	else: 
		swap.frame = 2

func _on_hidden():
	options.visible = false

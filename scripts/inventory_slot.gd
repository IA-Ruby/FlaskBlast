extends Control

@onready var slot = $Slot
@onready var sprite = $PotionSprite
@onready var amount = $Amount
@onready var potion_name = $Description/PotionName
@onready var description = $Description
@onready var options = $Options
@onready var craft = $Options/Craft
@onready var delete = $Options/Delete
@onready var swap = $Options/Swap
@onready var item_button = $ItemButton

var potion : Potion
var slot_index = -1
var swap_toggle = false

const button_inactive = 0
const button_active = 1
const button_pressed = 2
const button_disabled = 3

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

func set_potion(new_potion: Potion):
	potion = new_potion
	potion_name.text = new_potion.potion_name
	sprite.material.set_shader_parameter("new_color", new_potion.potion_color)
	sprite.frame = new_potion.potion_sprite
	amount.text = str(new_potion.potion_amount)

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
	craft.frame = button_pressed

func _on_craft_button_pressed():
	Global.open_craft(get_index())

func _on_craft_button_mouse_entered():
	craft.frame = button_active

func _on_craft_button_mouse_exited():
	craft.frame = button_inactive

func _on_del_button_button_down():
	delete.frame = button_pressed+12
	
func _on_del_button_pressed():
	Global.remove_potion(get_index())

func _on_del_button_mouse_entered():
	delete.frame = button_active+12

func _on_del_button_mouse_exited():
	delete.frame = button_inactive+12
	
func _on_swap_button_button_down():
	swap.frame = button_pressed+4

func _on_swap_button_pressed():
	if Global.potion_to_swap:
			Global.slot_swap(get_index())
	else:
		Global.potion_to_swap = get_index()
		swap_toggle = !swap_toggle
		if swap_toggle:
			swap.frame = button_pressed+4
		else: 
			swap.frame = button_active+4

func _on_swap_button_mouse_entered():
	if swap_toggle:
		swap.frame = button_pressed+4
	else:
		swap.frame = button_active+4

func _on_swap_button_mouse_exited():
	if swap_toggle:
		swap.frame = button_pressed+4
	else: 
		swap.frame = button_inactive+4

func _on_hidden():
	options.visible = false

extends Control

@onready var potion_sprite = $PotionSprite
@onready var target = $Target
@onready var increase_button_target = $Target/IncreaseButtonTarget
@onready var decrease_button_target = $Target/DecreaseButtonTarget
@onready var type = $Type
@onready var increase_button_type = $Type/IncreaseButtonType
@onready var decrease_button_type = $Type/DecreaseButtonType
@onready var amount = $Amount
@onready var increase_button_amount = $Amount/IncreaseButtonAmount
@onready var decrease_button_amount = $Amount/DecreaseButtonAmount
@onready var confirm = $Confirm
@onready var cancel = $Cancel
@onready var potion_name = $PotionName

const button_inactive = 0
const button_active = 1
const button_pressed = 2
const button_disabled = 3

var color_potion = Color(1.0,1.0,1.0,1.0)
var amount_potion = 1

func _ready():
	decrease_button_target.frame = button_disabled+20	
	decrease_button_type.frame = button_disabled+20
	decrease_button_amount.frame = button_disabled+20

func _process(_delta):
	self.visible = Global.crafting
	update_potion_sprite()
	
func update_potion_sprite():
	var potion_name_size
	match(amount_potion):
		1: potion_name_size = "Great"
		2: potion_name_size = "Medium"
		3: potion_name_size = "Minor"
		
	match(type.frame):
		4: 
			color_potion = Color.html("#f79617")
			name = str("Potion of " + potion_name_size + " Fire")
		5: 
			color_potion = Color.html("#8fd3ff")
			name = str("Potion of " + potion_name_size + " Ice")
		6: 
			color_potion = Color.html("#fbff86")
			name = str("Potion of " + potion_name_size + " Thunder")
		7: 
			color_potion = Color.html("#165a4c")
			name = str("Potion of " + potion_name_size + " Poison")
		8: 
			color_potion = Color.html("#ffffff")
			name = str("Potion of " + potion_name_size + " Light")
		9: 
			color_potion = Color.html("#9babb2")
			name = str("Potion of " + potion_name_size + " Protection")
		10: 
			color_potion = Color.html("#1ebc73")
			name = str("Potion of " + potion_name_size + " Haste")
		11: 
			color_potion = Color.html("#e83b3b")
			name = str("Potion of " + potion_name_size + " Healing")

	potion_name.text = name
	potion_sprite.material.set_shader_parameter("new_color", color_potion)
	potion_sprite.frame = (target.frame + ((amount_potion-1)*4)) #Big bain XD 
	
func _on_cancel_button_pressed():
	Global.crafting = false

func _on_cancel_button_mouse_entered():
	cancel.frame = button_active+3
	
func _on_cancel_button_mouse_exited():
	cancel.frame = button_inactive+3

func _on_cancel_button_button_down():
	cancel.frame = button_pressed+3

func _on_confirm_button_pressed():
	var new_potion = {
		"name": potion_name.text,
		"color": color_potion,
		"amount": amount_potion,
		"sprite": potion_sprite.frame,
		"potency": amount_potion,
		"type": type.frame,
		"target": target.frame, 
	}
	Global.add_potion(new_potion)
	Global.crafting = false

func _on_confirm_button_mouse_entered():
	confirm.frame = button_active

func _on_confirm_button_mouse_exited():
	confirm.frame = button_inactive

func _on_confirm_button_button_down():
	confirm.frame = button_pressed

func _on_increase_button_amount_pressed():
	if amount_potion < 3:
		amount_potion += 1
		amount.text = str(amount_potion)
		if decrease_button_amount.frame == button_disabled+20:
			decrease_button_amount.frame = button_inactive+20
	if amount_potion >= 3:
		increase_button_amount.frame = button_disabled+16
		amount_potion = 3 #just in case...

func _on_increase_button_amount_mouse_entered():
	if amount_potion < 3:
		increase_button_amount.frame = button_active+16
		
func _on_increase_button_amount_mouse_exited():
	if amount_potion < 3:
		increase_button_amount.frame = button_inactive+16

func _on_increase_button_amount_button_down():
	if amount_potion < 3:
		increase_button_amount.frame = button_pressed+16

func _on_decrease_button_amount_pressed():
	if amount_potion > 1:
		amount_potion -= 1
		amount.text = str(amount_potion)
		if increase_button_amount.frame == button_disabled+16:
			increase_button_amount.frame = button_inactive+16
	if amount_potion <= 1:
		decrease_button_amount.frame = button_disabled+20
		amount_potion = 1 #Just in case 2...

func _on_decrease_button_amount_mouse_entered():
	if amount_potion > 1:
		decrease_button_amount.frame = button_active+20

func _on_decrease_button_amount_mouse_exited():
	if amount_potion > 1:
		decrease_button_amount.frame = button_inactive+20

func _on_decrease_button_amount_button_down():
	if amount_potion > 1:
		decrease_button_amount.frame = button_pressed+20

func _on_increase_button_type_pressed():
	if type.frame < 11:
		type.frame += 1
		if decrease_button_type.frame == button_disabled+20:
			decrease_button_type.frame = button_inactive+20
	if type.frame >= 11:
		increase_button_type.frame = button_disabled+16

func _on_increase_button_type_mouse_entered():
	if type.frame < 11:
		increase_button_type.frame = button_active+16

func _on_increase_button_type_mouse_exited():
	if type.frame < 11:
		increase_button_type.frame = button_inactive+16

func _on_increase_button_type_button_down():
	if type.frame < 11:
		increase_button_type.frame = button_pressed+16

func _on_decrease_button_type_pressed():
	if type.frame > 4:
		type.frame -= 1
		if increase_button_type.frame == button_disabled+16:
			increase_button_type.frame = button_inactive+16
	if type.frame <= 4:
		decrease_button_type.frame = button_disabled+20

func _on_decrease_button_type_mouse_entered():
	if type.frame > 4:
		decrease_button_type.frame = button_active+20

func _on_decrease_button_type_mouse_exited():
	if type.frame > 4:
		decrease_button_type.frame = button_inactive+20

func _on_decrease_button_type_button_down():
	if type.frame > 4:
		decrease_button_type.frame = button_pressed+20

func _on_increase_button_target_pressed():
	if target.frame < 2:
		target.frame += 1
		if decrease_button_target.frame == button_disabled+20:
			decrease_button_target.frame = button_inactive+20
	if target.frame >= 2:
		increase_button_target.frame = button_disabled+16

func _on_increase_button_target_mouse_entered():
	if target.frame < 2:
		increase_button_target.frame = button_active+16

func _on_increase_button_target_mouse_exited():
	if target.frame < 2:
		increase_button_target.frame = button_inactive+16

func _on_increase_button_target_button_down():
	if target.frame < 2:
		increase_button_target.frame = button_pressed+16

func _on_decrease_button_target_pressed():
	if target.frame > 0:
		target.frame -= 1
		if increase_button_target.frame == button_disabled+16:
			increase_button_target.frame = button_inactive+16
	if target.frame <= 0:
		decrease_button_target.frame = button_disabled+20

func _on_decrease_button_target_mouse_entered():
	if target.frame > 0:
		decrease_button_target.frame = button_active+20

func _on_decrease_button_target_mouse_exited():
	if target.frame > 0:
		decrease_button_target.frame = button_inactive+20

func _on_decrease_button_target_button_down():
	if target.frame > 0:
		decrease_button_target.frame = button_pressed+20

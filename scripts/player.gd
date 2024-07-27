extends CharacterBody2D

const SPEED = 5000.0
var health := 10:
	set(value):
		health = clamp(value, 0, 10)
var shield := 0:
	set(value):
		shield = clamp(value, 0, 10)

@onready var animation_player = $AnimationPlayer
@onready var light = $Light
@onready var inventory_ui = $Inventory_Ui
@onready var inventory_hotbar = $Inventory_Hotbar
@onready var health_bar = $Health_Bar

func _ready():
	Global.set_player_reference(self)

func _physics_process(delta):
	move_player(delta)

func move_player(delta):
	var direction = Input.get_vector("left","right","up","down")	
	
	update_sprite(direction)
	
	if direction:
		self.velocity = SPEED * direction * delta 
		if direction.y != 0:
			self.velocity *=  Vector2(1,0.5) 
		if Input.is_action_pressed("sprint"):
			self.velocity *= 2
	else:
		self.velocity = Vector2.ZERO
		
	move_and_slide()
	
func update_sprite(direction):
	if(direction.x > 0):
		if(direction.y > 0): 
			animation_player.play("down_right")
		elif(direction.y < 0): 
			animation_player.play("top_right")
		else: 
			animation_player.play("right")
			
	if(direction.x < 0):
		if(direction.y > 0): 
			animation_player.play("down_left")
		elif(direction.y < 0): 
			animation_player.play("top_left")
		else: 
			animation_player.play("left")
	
	if(direction.x == 0):
		if(direction.y > 0): 
			animation_player.play("down")
		if(direction.y < 0): 
			animation_player.play("top")

func _input(event):
	if event.is_action_pressed("inventory"):
		inventory_ui.visible = !inventory_ui.visible 
		inventory_hotbar.visible = !inventory_hotbar.visible
		health_bar.visible = !health_bar.visible
		get_tree().paused = !get_tree().paused
		Global.potion_to_swap = null
		Global.fill_hotbar_row()
		Global.inventory_updated.emit()
		
	if event.is_action_pressed("toggle_light"):
		Global.player_light = !Global.player_light
		light.update_light(Global.player_light)
		
	if event.is_action_pressed("use_potion") and inventory_ui.visible == false:
		if Global.get_potion():
			var potion = Global.get_potion()
			Global.remove_potion(Global.active_slot+(Global.inventory_row*5))
			Global.fill_hotbar_row()
			potion_effect(potion)
		
	if event.is_action_pressed("change_hotbar"):
		Global.change_inventory_row()
		
	if event.is_action_pressed("slot1"): 
		Global.active_slot = 0
		Global.inventory_updated.emit()
		
	if event.is_action_pressed("slot2"): 
		Global.active_slot = 1
		Global.inventory_updated.emit()
		
	if event.is_action_pressed("slot3"):
		Global.active_slot = 2
		Global.inventory_updated.emit()
		
	if event.is_action_pressed("slot4"):
		Global.active_slot = 3
		Global.inventory_updated.emit()
		
	if event.is_action_pressed("slot5"): 
		Global.active_slot = 4
		Global.inventory_updated.emit()
		
	if event.is_action_pressed("scrow_right"):
		Global.active_slot -= 1
		if Global.active_slot < 0: Global.active_slot = 4
		Global.inventory_updated.emit()
		
	if event.is_action_pressed("scrow_left"): 
		Global.active_slot += 1
		if Global.active_slot > 4: Global.active_slot = 0
		Global.inventory_updated.emit()
	
func potion_effect(potion):
	match potion["type"]:
		0: #Self
			pass
		1: #Attack
			pass
	match potion["area"]:
		5: #SingleCollision
			pass
		6: #AOE
			pass
		7: #Aura/Buff
			pass
	match potion["effect"]:
		10: #FireDmg
			pass
		11: #IceDmg
			pass
		12: #Light
			pass
		15: #Armor
			pass
		16: #Speed
			pass
		17: #Health
			pass
			
func craft_potion():
	var new_potion = {
		"amount" : 1,
		"name": "Ultimate Test",
		"color": Color(1.0,1.0,1.0,1.0),
		"size": 8,
		"type": 0,
		"area": 5,
		"effect": 10,
	}
	Global.add_potion(new_potion,0)

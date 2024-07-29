extends CharacterBody2D

const SPEED = 5000.0

var health := 10:
	set(value):
		health = clamp(value, 0, 10)
var shield := 0:
	set(value):
		shield = clamp(value, 0, 10)
var stamina := 100.0:
	set(value):
		stamina = clamp(value, 0.0,100.0)
var light := 100.0:
	set(value):
		light = clamp(value,0.0,100.0)
var stamina_regen := 10.0
var light_regen := 20.0
var stamina_can_regen := true
var light_can_regen := true

@onready var camera = $Camera
@onready var animation_player = $AnimationPlayer
@onready var light_player = $Light_player
@onready var inventory_ui = $Inventory_Ui
@onready var general_ui = $General_UI
@onready var inventory_hotbar = $General_UI/Inventory_Hotbar
@onready var stamina_bar = $General_UI/Stamina_Bar
@onready var health_bar = $General_UI/Health_Bar
@onready var light_bar = $General_UI/Light_Bar
@onready var interact = $General_UI/Interact
@onready var stamina_timer = $Stamina_Timer
@onready var light_timer = $Light_Timer

func _ready():
	Global.set_player_reference(self)

func _physics_process(delta):
	if stamina_can_regen:
		stamina += stamina_regen * delta
	move_player(delta)
	stamina_bar.update_stamina_bar(stamina)

	if light_can_regen:
		light += light_regen * delta
	check_light(delta)
	light_bar.update_light_bar(light)
	
	health_bar.update_health_bar(health,shield)
	
	check_interact()
	
func _input(event):
	if event.is_action_pressed("use_potion") and inventory_ui.visible == false:
		if Global.get_potion():
			var potion = Global.get_potion()
			Global.remove_potion(Global.active_slot+(Global.inventory_row*5))
			Global.fill_hotbar_row()
			potion_effect(potion["target"],potion["type"],potion["size"])
		
	if event.is_action_pressed("inventory"):
		if Global.crafting:
			Global.crafting = false
		else:
			inventory_hotbar.visible = !inventory_hotbar.visible
			general_ui.visible = !general_ui.visible
			inventory_ui.visible = !inventory_ui.visible 
			if !inventory_ui.visible:
				Global.crafting = false
			
			Global.potion_to_swap = null
			Global.fill_hotbar_row()
			Global.inventory_updated.emit()	
		
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
	
func move_player(delta):
	var direction = Input.get_vector("left","right","up","down")	
	if direction:
		self.velocity = SPEED * direction * delta 
		if direction.y != 0:
			self.velocity *=  Vector2(1,0.5) 
		if Input.is_action_pressed("sprint") and stamina > 0.0:
			self.velocity *= 2
			stamina -= 25.0 * delta
			stamina_can_regen = false
			stamina_timer.start()
	else:
		self.velocity = Vector2.ZERO
	update_sprite(direction)
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

func check_light(delta):
	if Input.is_action_pressed("toggle_light") and light > 0.0:
		Global.player_light = true #Maybe useless
		light_player.update_light(true)
		light_timer.start()
		light -= 25.0 * delta
		light_can_regen = false
	else:
		Global.player_light = false
		light_player.update_light(false)
	
func check_interact():
	if !inventory_ui.visible:
		if Global.interact_nearby:
			interact.visible = true
		else:
			interact.visible = false
	else:
		interact.visible = false

func potion_effect(target,type,size):
	match target:
		0: apply_potion_self(type,size)
		1: trown_potion_single(type,size)
		2: trown_potion_aoe(type,size)
		3: trown_potion_area(type,size)

func apply_potion_self(type,size):
	match type:
		4: pass
		5: pass
		6: pass
		7: pass
		8: pass
		9: pass
		10: pass
		11: health += 1
		
func trown_potion_single(type,size):
	pass
func  trown_potion_aoe(type,size):
	pass
func trown_potion_area(type,size):
	pass
func _on_light_timer_timeout():
	light_can_regen = true
	
func _on_stamina_timer_timeout():
	stamina_can_regen = true

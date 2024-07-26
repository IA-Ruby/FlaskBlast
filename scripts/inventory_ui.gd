extends Control

@onready var grid_container = $GridContainer

func _ready():
	Global.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_inventory_updated():
	clear_grid_container()
	for potion in Global.inventory:
		var slot = Global.inventory_slot_scene.instantiate()
		grid_container.add_child(slot)
		if potion != null:
			slot.set_potion(potion)
		else:
			slot.set_empty()
	
func clear_grid_container():
	while(grid_container.get_child_count()):
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()

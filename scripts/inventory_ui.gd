extends Control

@onready var grid_container = $GridContainer

func _ready():
	Global.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_inventory_updated():
	clear_grid_container()
	
func clear_grid_container():
	while(grid_container.get_child_count()):
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()

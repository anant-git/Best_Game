extends Node2D

@onready var tilemap: TileMapLayer = $TileMap/TileMapLayer  # Replace with your actual node name
@onready var ladder_scene = preload("res://ladder_test.tscn")
@onready var LadderScene: PackedScene = preload("res://ladder_test.tscn")
@export var ladder_counter: int = 4
signal show_ladder_placeholder

func get_cells_with_atlas(atlas_target: Vector2i) -> Array:
	var result: Array = []
	var tile_size: int = 16
	var map_width_px: int = 1280  # adjust to match your scene size in pixels
	var map_height_px: int = 640

	for px_x in range(0, map_width_px, tile_size):
		for px_y in range(0, map_height_px, tile_size):
			var cell: Vector2i = Vector2i(px_x / tile_size, px_y / tile_size)
			var atlas_coords: Vector2i = tilemap.get_cell_atlas_coords(cell)
			if atlas_coords == atlas_target and not result.has(cell):
				result.append(cell)

	return result

func _ready():
	var matches = get_cells_with_atlas(Vector2i(16, 9))
	#print("Matching cells:", matches)

func _process(delta):
	var platform_matches = check_cells(Vector2i(16, 9))
	#print("Matching platforms:", platform_matches)
	update_ladder_placeholder(Vector2i(16, 9))

func check_cells(atlas_target: Vector2i) -> Array:
	var tile_size: int = 16
	var local_mouse_pos: Vector2 = tilemap.to_local(get_global_mouse_position())
	var cell_pos: Vector2i = Vector2i(local_mouse_pos.x / tile_size, local_mouse_pos.y / tile_size)

	var x_value: int = cell_pos.x
	var range_up: int = cell_pos.y + 3
	var range_down: int = cell_pos.y - 3
	var temp_array: Array = []

	for y_value in range(range_down, range_up + 1):
		if y_value == cell_pos.y:
			continue
		var cell: Vector2i = Vector2i(x_value, y_value)
		var atlas_coords: Vector2i = tilemap.get_cell_atlas_coords(cell)
		if atlas_coords == atlas_target:
			temp_array.append(cell)

	if temp_array.size() == 2:
		return temp_array
	else:
		return []

func update_ladder_placeholder(atlas_target: Vector2i) -> void:
	var matched_cells: Array = check_cells(atlas_target)

	if matched_cells.size() == 2:
		var lower_cell: Vector2i
		if matched_cells[0].y > matched_cells[1].y:
			lower_cell = matched_cells[0]
		else:
			lower_cell = matched_cells[1]

		var world_pos: Vector2 = tilemap.to_global(Vector2(lower_cell) * 16)
		world_pos.y -= 48  # Apply Y-axis offset
		$ladder_placeholder.global_position = world_pos
		$ladder_placeholder.visible = true
	else:
		$ladder_placeholder.visible = false

func _unhandled_input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed \
	and not event.is_echo() \
	and $ladder_placeholder.visible \
	and ladder_counter > 0:

		var ladder_instance = LadderScene.instantiate()
		ladder_instance.global_position = $ladder_placeholder.global_position
		get_tree().current_scene.add_child(ladder_instance)

		ladder_instance.connect("ladder_right_clicked", Callable(self, "_on_ladder_right_clicked"))
		ladder_counter -= 1
		$ladder_placeholder.visible = false

func _on_ladder_right_clicked(ladder_node: Node2D) -> void:
	ladder_node.queue_free()
	ladder_counter += 1

extends Node2D

@onready var tilemap: TileMapLayer = $TileMap/Layer1
@onready var LadderScene: PackedScene = preload("res://ladder_test.tscn")
@onready var ladder_placeholder = $ladder_placeholder
@onready var menu = $Menu
@export var ladder_counter: int = 4
@onready var enemies = get_tree().get_nodes_in_group("enemy")
@onready var player = $Player_Main

func _ready():
	$ladder_placeholder.signal_enabled = false
	$ladder_placeholder.modulate.a = 0.5
	process_mode = Node.PROCESS_MODE_INHERIT
	var matches = get_cells_with_atlas(Vector2i(16, 9))
	print("Initial matching cells:", matches)
	for enemy in enemies:
		enemy.damage_to_player.connect(player._on_enemy_damage_to_player)

func _process(delta):
	if not menu.visible:
		update_ladder_placeholder(Vector2i(16, 9))

func _on_player_main_start_menu():
	get_tree().paused = true
	menu.visible = true
	menu.get_node("Panel/PanelContainer/MarginContainer/VBoxContainer/Resume").disabled = true

func get_cells_with_atlas(atlas_target: Vector2i) -> Array:
	var result: Array = []
	var tile_size: int = 16
	var map_width_px: int = 1280
	var map_height_px: int = 640

	for px_x in range(0, map_width_px, tile_size):
		for px_y in range(0, map_height_px, tile_size):
			@warning_ignore("integer_division")
			var cell: Vector2i = Vector2i(px_x / tile_size, px_y / tile_size)
			var atlas_coords: Vector2i = tilemap.get_cell_atlas_coords(cell)
			if atlas_coords == atlas_target and not result.has(cell):
				result.append(cell)

	return result

func check_cells(atlas_target: Vector2i) -> Array:
	var tile_size: int = 16
	var local_mouse_pos: Vector2 = tilemap.to_local(get_global_mouse_position())
	@warning_ignore("narrowing_conversion")
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

	return temp_array if temp_array.size() == 2 else []

func update_ladder_placeholder(atlas_target: Vector2i) -> void:
	var matched_cells: Array = check_cells(atlas_target)

	if matched_cells.size() == 2:
		var lower_cell: Vector2i = matched_cells[0] if matched_cells[0].y > matched_cells[1].y else matched_cells[1]
		var world_pos: Vector2 = tilemap.to_global(Vector2(lower_cell + Vector2i(1, 0)) * 16)
		world_pos.y -= 48
		world_pos.x -= 12
		ladder_placeholder.global_position = world_pos
		ladder_placeholder.visible = true
		#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		ladder_placeholder.visible = false
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#
	## Check overlap with placed ladders
	#var overlapped := false
	#for ladder in get_tree().get_nodes_in_group("ladder"):
		#if ladder != ladder_placeholder:
			#if ladder.get_rect().has_point(ladder_placeholder.global_position):
				#overlapped = true
				#break
#
	## Change color if overlapping
	#if overlapped:
		#ladder_placeholder.modulate = Color.RED
	#else:
		#ladder_placeholder.modulate = Color(1, 1, 1, 0.5)  # default transparent white

func _unhandled_input(event):
	if menu.visible:
		return

	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == KEY_ESCAPE:
			_handle_escape()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not event.is_echo():
		_handle_left_click()

func _handle_escape():
	get_tree().paused = true
	menu.visible = true
	menu.get_node("Panel/PanelContainer/MarginContainer/VBoxContainer/Resume").disabled = false

func _handle_left_click():
	if ladder_placeholder.visible and ladder_counter > 0:
		var ladder_instance = LadderScene.instantiate()
		ladder_instance.global_position = ladder_placeholder.global_position
		ladder_instance.signal_enabled = true
		get_tree().current_scene.add_child(ladder_instance)
		#ladder_instance.add_to_group("ladder")
		ladder_instance.player_entered.connect($Player_Main._on_ladder_placeholder_player_entered)
		ladder_instance.player_exit.connect($Player_Main._on_ladder_placeholder_player_exit)

		ladder_instance.connect("ladder_right_clicked", Callable(self, "_on_ladder_right_clicked"))
		ladder_counter -= 1
		ladder_placeholder.visible = false

func _on_ladder_right_clicked(ladder_node: Node2D) -> void:
	if menu.visible:
		return 
	ladder_node.queue_free()
	ladder_counter += 1

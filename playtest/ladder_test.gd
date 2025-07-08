extends Node2D

signal ladder_right_clicked
signal player_entered
signal player_exit

var signal_enabled := true

#func get_rect() -> Rect2:
	#return Rect2(global_position - Vector2(8, 24), Vector2(16, 48))  # adjust to ladder size

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and event.pressed \
	and not event.is_echo():
		emit_signal("ladder_right_clicked", self)

func _ready():
	$Area2D.connect("input_event", Callable(self, "_on_area_input_event"))

func _on_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		emit_signal("ladder_right_clicked", self)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if signal_enabled and body.name == "Player_Main":
		emit_signal("player_entered", body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if signal_enabled and body.name == "Player_Main":
		emit_signal("player_exit", body)

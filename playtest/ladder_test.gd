extends Node2D

signal ladder_right_clicked

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

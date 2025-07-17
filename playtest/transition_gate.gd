@tool
extends Area2D

@export_enum("Level1", "Level2", "Level3") var level = "Level1"
var levels = {}
signal game_ui_visibility

func _ready():
	if not Engine.is_editor_hint():
		levels['Level1'] = 'res://Level1.tscn'
		levels['Level2'] = 'res://Level2.tscn'
		levels['Level3'] = 'res://Level3.tscn'

func _on_body_entered(_body: Node2D) -> void:
	emit_signal('game_ui_visibility')
	TransitionLayer.change_scene(levels[level])

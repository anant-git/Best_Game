extends Control

@onready var resume_button = $Panel/PanelContainer/MarginContainer/VBoxContainer/Resume

func _ready():
	resume_button.disabled = true

func _on_start_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Level1.tscn")

func _on_exit_game_pressed():
	get_tree().quit()

func _on_resume_pressed():
	hide()
	get_tree().paused = false

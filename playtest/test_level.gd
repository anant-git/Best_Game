extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("Escape"):
		get_tree().paused = true
		$Menu.visible = true
		$Menu/Panel/PanelContainer/MarginContainer/VBoxContainer/Resume.disabled = false

func _on_player_main_start_menu():
	get_tree().paused = true
	$Menu.visible = true
	$Menu/Panel/PanelContainer/MarginContainer/VBoxContainer/Resume.disabled = true

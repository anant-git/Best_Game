extends Node2D

var ladder_scene = preload("res://ladder_test.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("Escape"):
		get_tree().paused = true
		$Menu.visible = true
		$Menu/Panel/PanelContainer/MarginContainer/VBoxContainer/Resume.disabled = false

func _on_player_main_start_menu():
	get_tree().paused = true
	$Menu.visible = true
	$Menu/Panel/PanelContainer/MarginContainer/VBoxContainer/Resume.disabled = true

#Placing the ladder in a scene
#func inst_ladder(pos):
	#var instance = ladder_scene.instantiate()
	#instance.position = pos
	#add_child(instance)
#
#func _process(delta):
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#inst_ladder(get_global_mouse_position())

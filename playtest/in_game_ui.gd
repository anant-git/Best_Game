extends CanvasLayer

func _on_level_name_change(level_name):
	$LevelNameLabel.text = " " + level_name

func _on_ladder_change(ladder_count):
	$Ladders.text = "Ladders - " + str(ladder_count)

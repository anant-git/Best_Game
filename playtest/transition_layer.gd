extends CanvasLayer

func _ready():
	$ColorRect.modulate = Color(0, 0)
	$ColorRect.visible = 0

func change_scene(target):
	var tween = create_tween()
	tween.tween_property($ColorRect, 'visible', true, 0)
	tween.tween_property($ColorRect, 'modulate', Color(0, 1), 0.5)
	tween.tween_callback(Callable(self, 'open_scene').bind(target))
	tween.tween_property($ColorRect, 'modulate', Color(0, 0), 0.5)
	tween.tween_property($ColorRect, 'visible', false, 0)

func open_scene(scene_path):
	get_tree().change_scene_to_file((scene_path))

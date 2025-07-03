extends CharacterBody2D

@export var speed: float = 200
var direction: Vector2 = Vector2(1, 0) # 1 = right, -1 = left
@export var climb_speed := 100
@export var gravity := 400.0
@export var gravity_multiplier := 100

@onready var player = get_tree().get_first_node_in_group("player_main")

signal damage_to_player

func _physics_process(delta):
	velocity.x = speed * direction.x
	velocity.y += gravity * gravity_multiplier * delta

	if is_on_floor():
		$AnimatedSprite2D.play("walk")

	move_and_slide()

	# Reverse direction when hitting a wall
	if is_on_wall():
		var current_direction = direction.x
		direction.x *= -1
		$AnimatedSprite2D.flip_h = direction.x < 0

#func damage_detection(body: CharacterBody2D):
#	if body.has_method("death"):
#		emit_signal("damage_to_player")
#		print("Player_Detected")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("death"):
		emit_signal("damage_to_player")

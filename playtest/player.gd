extends CharacterBody2D

@export var speed: float = 500
var direction: int = 1  # 1 = right, -1 = left
@export var climb_speed := 200
@export var gravity := 400.0
var on_ladder := false
@export var gravity_multiplier := 100

func _physics_process(delta):
	velocity.x = speed * direction

	#if not on_ladder:
		#velocity.y = 0

	if on_ladder:
		velocity.y = -climb_speed
		velocity.x = 0
	else:
		velocity.y += gravity * gravity_multiplier * delta

	move_and_slide()

	# Reverse direction when hitting a wall
	if is_on_wall():
		direction *= -1

func _on_ladder_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		on_ladder = true


func _on_ladder_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		on_ladder = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		on_ladder = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		on_ladder = false

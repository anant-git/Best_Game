extends CharacterBody2D

@export var speed: float = 200
var direction: Vector2 = Vector2(1, 0) # 1 = right, -1 = left
@export var climb_speed := 100
@export var gravity := 400.0
var on_ladder := false
@export var gravity_multiplier := 100
signal player_is_dead
@onready var enemy = get_tree().get_first_node_in_group("enemy")



func death():
	print("Player Died")

func _physics_process(delta):
	velocity.x = speed * direction.x

	if is_on_floor():
		$Sprite2D.play("walk")

	if is_on_floor():
		$GPUParticles2D.emitting = true
	else:
		$GPUParticles2D.emitting = false

	if on_ladder:
		velocity.y = -climb_speed
		velocity.x = 0
	else:
		velocity.y += gravity * gravity_multiplier * delta

	move_and_slide()

	# Reverse direction when hitting a wall
	if is_on_wall():
		var current_direction = direction.x
		direction.x *= -1
		$Sprite2D.flip_h = direction.x < 0
		$GPUParticles2D.position.x = -$GPUParticles2D.position.x
		var material := $GPUParticles2D.process_material as ParticleProcessMaterial
		material.gravity.x = -material.gravity.x
		var img = $GPUParticles2D.texture.get_image()
		img.flip_x()
		$GPUParticles2D.texture = ImageTexture.create_from_image(img)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player_Main":
		on_ladder = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player_Main":
		on_ladder = false

#func _on_enemy_damage_to_player():
#	print("Enemy_Detected")
#	death()

func _on_enemy_damage_to_player():
	pass

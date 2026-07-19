extends CharacterBody2D

signal HealthChanged

const SPEED = 300.0
@export var MaxHealth = 5
@onready var CurrentHealth = MaxHealth
@export var fireScene: PackedScene

@onready var WalkAnimation = $AnimatedSprite2D
@onready var FireScene = preload("res://scenes/fire.tscn")  # Coloque o caminho correto da sua cena de fogo

var fire_timer = 0.0
var fire_cooldown = 1.0  # Intervalo de tempo entre os disparos de fogo

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	var directionY := Input.get_axis("ui_up", "ui_down")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if directionY:
		velocity.y = directionY * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	
	# Disparo de fogo
	if Input.is_action_just_pressed("ui_accept") and fire_timer <= 0.0:  # ui_accept corresponde ao botão espaço
		disparar_fogo()
		fire_timer = fire_cooldown
	
	# Atualiza o timer do fogo
	if fire_timer > 0.0:
		fire_timer -= delta

func disparar_fogo():
	var fire_instance = FireScene.instantiate()  # Instancia a cena do fogo
	var fire_position = position  # Posição inicial do fogo

	# Ajuste a posição do fogo com base na direção do movimento
	var distance = 100  # Aumentei a distância do fogo para 100 para mais afastado
	if WalkAnimation.animation == "up":
		fire_position += Vector2(0, -distance)  # Ajuste a posição para cima
	elif WalkAnimation.animation == "down":
		fire_position += Vector2(0, distance)  # Ajuste a posição para baixo
	elif WalkAnimation.animation == "left":
		fire_position += Vector2(-distance, 0)  # Ajuste a posição para a esquerda
	elif WalkAnimation.animation == "right":
		fire_position += Vector2(distance, 0)  # Ajuste a posição para a direita
	
	# Atualiza a posição do fogo com base na direção
	fire_instance.position = fire_position

	get_parent().add_child(fire_instance)  # Adiciona o fogo na cena
	print("Fogo disparado!")

func _on_hurt_box_area_entered(area):
	if area.name == "hitBox":
		CurrentHealth -= 1
		print_debug(CurrentHealth)
		HealthChanged.emit(CurrentHealth)
		if CurrentHealth <= 0:
			get_tree().reload_current_scene()

func _process(delta):
	if Input.is_action_pressed("ui_down"):
		WalkAnimation.play("down")
	elif Input.is_action_pressed("ui_up"):
		WalkAnimation.play("up")
	elif Input.is_action_pressed("ui_right"):
		WalkAnimation.play("right")
	elif Input.is_action_pressed("ui_left"):
		WalkAnimation.play("left")
	else:
		WalkAnimation.stop()

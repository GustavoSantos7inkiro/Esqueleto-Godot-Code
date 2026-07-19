extends CharacterBody2D

@export var SPEED: float = 100
var random_direction: Vector2 = Vector2.ZERO
var change_direction_timer: float = 0.0
var health: int = 1  # Vida inicial do inimigo

func _ready() -> void:
	# Adiciona o inimigo ao grupo "inimigo"
	add_to_group("inimigo")
	change_direction_timer = randf_range(0, 1.0)

func _physics_process(delta: float) -> void:
	change_direction_timer -= delta
	
	if change_direction_timer <= 0:
		random_direction = Vector2(randf_range(-1.0, 1.0), 
		randf_range(-1.0, 1.0)).normalized()
		
		change_direction_timer = randf_range(0.1, 0.5)
		
	velocity = random_direction * SPEED
	move_and_slide()

# Função que o inimigo vai usar para tomar dano
func take_damage() -> void:
	health -= 1
	if health <= 0:
		die()

# Função que é chamada quando o inimigo morre
func die() -> void:
	queue_free()  # Remove o inimigo da cena

# Detecção de colisão com o fogo
func _on_Fire_body_entered(body):
	# Verifica se o corpo que entrou é o fogo
	if body.is_in_group("fogo"):  
		take_damage()  # Chama a função para reduzir a vida do inimigo
		print("Inimigo levou dano! Vida: ", health)  # Imprime o valor da vida atual

@onready var WalkAnimation = $AnimatedSprite2D
func _process(delta: float) -> void:
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x >0:
				WalkAnimation.flip_h = false
				WalkAnimation.play("lados")
			else:
				WalkAnimation.flip_h = true
				WalkAnimation.play("lados")
		else:
			if velocity.y > 0:
				WalkAnimation.play("baixo")
			else:
				WalkAnimation.play("cima")

extends Area2D

@export var lifetime: float = 0.2  # Tempo que o fogo fica na tela

func _ready():
	$AudioStreamPlayer2D.play()  # Toca o som do disparo
	await get_tree().create_timer(lifetime).timeout  # Espera um tempo
	queue_free()  # Remove o fogo da cena

func _on_body_entered(body):
	if body.is_in_group("inimigo"):  # Se tocar no inimigo
		body.take_damage()  # Chama a função de dano no inimigo

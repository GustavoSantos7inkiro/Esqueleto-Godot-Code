extends Panel


@onready var sprite = $Sprite2D

func update(whole: bool):
	if whole: sprite.visible = false
	else: sprite.visible = true

extends Node2D

@onready var HeartBoneContainer = $CanvasLayer/heartBoneContainer
@onready var player = $Player

func _ready() -> void:
	HeartBoneContainer.setMaxBones(player.CurrentHealth)
	HeartBoneContainer.updateBone(player.CurrentHealth)
	player.HealthChanged.connect(HeartBoneContainer.updateBone)

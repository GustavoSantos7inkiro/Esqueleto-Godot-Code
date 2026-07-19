extends HBoxContainer

@onready var BoneGuiClass = preload("res://scenes/heart_bone.tscn")

func setMaxBones(Max: int):
	for i in range(Max):
		var heart_bone = BoneGuiClass.instantiate()
		add_child(heart_bone)

func updateBone(CurrentHealth: int):
	var bones = get_children()
	
	for i in range(CurrentHealth):
		bones[i].update(false)
		
	for i in range(CurrentHealth, bones.size()):
		bones[i].update(true)

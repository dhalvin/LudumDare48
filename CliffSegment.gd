extends StaticBody2D

export(String ,"easy", "medium", "hard") var difficulty = "easy" 

func get_area():
	return $Area2D

func _init_sprite(sprite):
	self.add_child(sprite)
	return self

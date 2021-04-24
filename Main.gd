extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.attach_to_anchor($CliffFace/Position2D.global_position)
	$Camera2D.position = $Player.position - Vector2(350, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera2D.position.y = $Player.position.y

extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
export (NodePath) var path_to_path_node = null
var movement_path = null
var pos_on_path = 0
export var speed = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	if path_to_path_node:
		set_path(get_node(path_to_path_node))
		self.position = movement_path[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not movement_path:
		return
	var next_point = movement_path[pos_on_path]
	if self.position.distance_squared_to(next_point) < 1:
		pos_on_path = wrapi(pos_on_path + 1, 0, movement_path.size())
		next_point = movement_path[pos_on_path]
	var velocity = (next_point - self.position).normalized() * speed
	move_and_slide(velocity)

func set_path(path_node):
	movement_path = path_node.curve.get_baked_points()

extends RigidBody2D


# Declare member variables here. Examples:
#var start_pos = Vector2.ZERO
#var reset_requested = false

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _integrate_forces(state):
#	if reset_requested:
#		reset(state)

func release():
	self.gravity_scale = 1
	self.apply_impulse(Vector2.ZERO, Vector2(1,1))
	
#func reset(state):
#	state.set_angular_velocity(0)
#	self.rotation = 0
#	state.set_linear_velocity(Vector2.ZERO)
#	self.gravity_scale = 0
#	var test = state.total_gravity
#	self.position = start_pos
#	reset_requested = false

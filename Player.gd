extends KinematicBody2D


# Declare member variables here. Examples:
export var max_jump_force = 700
export var gravity = 200
export var gravitx = 450
export var charge_speed = 100
export var terminal_velocity = 200

var current_anchor = null

export var velocity = Vector2()
var _on_cliff = false

var jump_progress = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_jump") and _on_cliff:
		jump_progress = clamp(jump_progress + charge_speed * delta, 0, 100)
		$TextureProgress.value = jump_progress

	if Input.is_action_just_released("ui_jump") and _on_cliff and jump_progress > 0:
		velocity.x -= jump_progress/100.0 * max_jump_force
		jump_progress = 0
		$TextureProgress.value = jump_progress
		_on_cliff = false

	if not _on_cliff:
		velocity += Vector2(gravitx, gravity) * delta
		
	velocity.y = min(velocity.y, terminal_velocity)
	
	var collision = self.move_and_collide(velocity * delta)
	if collision:
		_on_cliff = true
		velocity = Vector2()
		
	update_rappel()
	
func attach_to_anchor(anchor_pos):
	current_anchor = anchor_pos
	update_rappel()
	
func update_rappel():
	$RappelLine.points[1] = current_anchor - self.position

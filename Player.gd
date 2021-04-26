extends KinematicBody2D

signal fell

# Declare member variables here. Examples:
export var max_jump_force = 700
export var gravity = 200
export var gravitx = 450
export var charge_speed = 100
export var terminal_velocity = 200

var current_anchor = null

export var velocity = Vector2()
var _on_cliff = false
var is_anchored = false
var jump_progress = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.add_child($CollisionShape2D.duplicate())
	$Area2D.connect("body_entered", self, "_on_body_entered")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_jump") and _on_cliff:
		$JumpBar.visible = true
		$AnimationPlayer.play("charge_jump")
		
	if Input.is_action_pressed("ui_jump") and _on_cliff:
		jump_progress = clamp(jump_progress + charge_speed * delta, 0, 100)
		$JumpBar.value = jump_progress

	if Input.is_action_just_released("ui_jump") and _on_cliff and jump_progress > 0:
		velocity.x -= jump_progress/100.0 * max_jump_force
		jump_progress = 0
		$JumpBar.value = jump_progress
		$JumpBar.visible = false
		_on_cliff = false
		$AnimationPlayer.play_backwards("charge_jump")

	if not _on_cliff:
		velocity += Vector2(gravitx, gravity) * delta
		
	velocity.y = min(velocity.y, terminal_velocity)
	
	var collision = self.move_and_collide(velocity * delta)
	if collision and collision.get_collider().is_in_group("cliff"):
		_on_cliff = true
		velocity = Vector2()
		
	update_rappel()
	
func attach_to_anchor(anchor_pos):
	is_anchored = true
	current_anchor = anchor_pos
	update_rappel()
	
func update_rappel():
	if is_anchored:
		$Body/RappelLine.points[2] = current_anchor - self.position

func fall():
	velocity.x = 0
	gravitx = -10
	gravity = 1000
	terminal_velocity = 500
	self.collision_layer = 0
	$Body/RappelLine.points[2] = $Body/RappelLine.points[2].normalized() * 200
	_on_cliff = false
	is_anchored = false
	if $AnimationPlayer.current_animation != "falling" and $AnimationPlayer.current_animation != "falling_start":
		$AnimationPlayer.play("falling_start")
		$AnimationPlayer.queue("falling")
	
func _on_body_entered(body):
	if body.is_in_group("obstacles"):
		body.activate()
		fall() 
		emit_signal("fell")
	elif body.is_in_group("enemies"):
		fall() 
		emit_signal("fell")

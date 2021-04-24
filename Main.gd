extends Node

const PlayerScene = preload("res://Player.tscn")

# Declare member variables here. Examples:
var player_falling = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$GameoverTimer.connect("timeout", self, "gameover")
	spawnPlayer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not player_falling:
		$Camera2D.position.y = $Player.position.y

func _on_player_fell():
	player_falling = true
	$GameoverTimer.start()

func spawnPlayer():
	$GameoverTimer.stop()
	self.add_child(PlayerScene.instance())
	$Player.connect("fell", self, "_on_player_fell")
	$Player.attach_to_anchor($CliffFace/Position2D.global_position)
	$Player.position = $PlayerStart.global_position
	$Camera2D.position = $Player.position - Vector2(350, 0)
	player_falling = false
	
func gameover():
	$Player.connect("tree_exited", self, "spawnPlayer")
	$Player.queue_free()

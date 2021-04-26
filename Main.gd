extends Node

const PlayerScene = preload("res://Player.tscn")
const WorldScene = preload("res://CliffFace.tscn")

# Declare member variables here. Examples:
var player_falling = false

const PIXELS_PER_METER = 64/1.7
const CLIFF_OFFSET = Vector2(1200, 0)
export var camera_offset = Vector2(300, 200)
# Called when the node enters the scene tree for the first time.
func _ready():
	#$Camera2D/HUD/CenterContainer/PopupDialog.popup()
	randomize()
	$Camera2D/HUD.set_position(-0.5*get_viewport().size)
	$GameoverTimer.connect("timeout", self, "gameover")
	spawnPlayer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not player_falling:
		$Camera2D.position.y = $Player.position.y + camera_offset.y
		$Camera2D/HUD/PanelContainer/Depth/Value.text = "%.2f m" % [$Player.position.y/PIXELS_PER_METER]

func _on_player_fell():
	player_falling = true
	$GameoverTimer.start()

func spawnPlayer():
	self.add_child(PlayerScene.instance())
	$Player.connect("fell", self, "_on_player_fell")
	$Player.attach_to_anchor($CliffFace.position - Vector2($CliffFace.CLIFF_WIDTH/2, 0))
	$Player.position = $PlayerStart.global_position
	$Camera2D.position = $Player.position - camera_offset
	player_falling = false
	$CliffFace.load_segment(0)
	$CliffFace.load_segment(1)

func reloadWorld():
	self.add_child(WorldScene.instance())
	$CliffFace.position += CLIFF_OFFSET
	$Player.connect("tree_exited", self, "spawnPlayer")
	$Player.queue_free()
	
func gameover():
	$CliffFace.connect("tree_exited", self, "reloadWorld")	
	$CliffFace.queue_free()

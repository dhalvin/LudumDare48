extends Node2D

# Declare member variables here. Examples:
var cliff_segments = []
export var level_count = 4
const SEGMENT_HEIGHT = 2048
const CLIFF_WIDTH = 1024
export var SEGMENTS_PER_SECTION = 5
export var TOTAL_SECTIONS = 2
var theme_list = ["none", "none"]
var segment_instances = {}
var levels = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	read_levels()
	generate_segments()
	load_segment(0)
	load_segment(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_segment(idx):
	if idx >= 0 and idx < cliff_segments.size() and not segment_instances.has(idx):
		segment_instances[idx] = create_segment(cliff_segments[idx], idx)
		segment_instances[idx].position = Vector2(0, idx * SEGMENT_HEIGHT + SEGMENT_HEIGHT/2)
		self.call_deferred("add_child", segment_instances[idx])
	
func unload_segment(idx):
	if idx >= 0 and idx < cliff_segments.size():
		var segment = segment_instances[idx]
		if segment.get_parent():
			segment.queue_free()

func enter_segment(idx):
	unload_segment(idx - 2)
	for i in range(idx - 1, idx + 2):
		if i >= 0:
			load_segment(i)

func _on_player_entered_segment(body, idx):
	if body.is_in_group("player"):
		enter_segment(idx)
		
func read_levels():
	for i in range(1, level_count + 1):
		var level = load("res://levels/Level%d.tscn" % i).instance()
		if(not levels.has(level.difficulty)):
			levels[level.difficulty] = []
		levels[level.difficulty].append("Level%d" % i)

func generate_segments():
	for section in TOTAL_SECTIONS:
		for segment in SEGMENTS_PER_SECTION:
			var difficultyFactor = section*2.0 + segment/2.0 - 1
			var difficulty = ""
			var r = randf()
			if r < 0.7 - (difficultyFactor/10):
				difficulty = "easy"
			elif r < 1.0 - (difficultyFactor/20):
				difficulty = "medium"
			else:
				difficulty = "hard"
			var choice = randi() % levels[difficulty].size()
			var segment_name = levels[difficulty][choice]
			cliff_segments.append(segment_name)

func create_segment(level_name, idx):
	var segment = load("res://levels/%s.tscn" % level_name).instance()
	segment.collision_layer = 2
	segment.collision_mask = 2
	
	segment.get_area().connect("body_entered", self, "_on_player_entered_segment", [idx])
	
	var sprite = $Sprite.duplicate()
	sprite.visible = true
	segment._init_sprite(sprite)
	return segment

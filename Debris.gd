extends StaticBody2D


# Declare member variables here. Examples:
onready var debris_list = [$Debris_Body, $Debris_Body2, $Debris_Body3, $Debris_Body4, $Debris_Body5]

# Called when the node enters the scene tree for the first time.
func _ready():
	$DespawnTimer.connect("timeout", self, "despawn")
#	for debris in debris_list:
#		debris.start_pos = debris.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if $RayCast2D.is_colliding() and $RayCast2D.get_collider().is_in_group("player"):
		$RayCast2D.enabled = false
		self.activate()

func activate():
	for debris in debris_list:
		debris.release()
	$DespawnTimer.start()
	
func despawn():
	for debris in debris_list:
		debris.queue_free()

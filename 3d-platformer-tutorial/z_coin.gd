extends Area3D

const ROTATION_SPEED = 2 # number of degrees the coin will spin every frame

func rotate_coin() -> void:
	rotate_y(deg_to_rad(ROTATION_SPEED))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_coin()

func _on_body_entered(body: Node3D) -> void:
	$AnimationPlayer.play("bounce")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free() # Replace with function body.

extends Area3D

const ROTATION_SPEED = 2 # number of degrees the coin will spin every frame

func rotate_coin() -> void:
	rotate_y(deg_to_rad(ROTATION_SPEED)) # Rotate coin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_coin()

func _on_body_entered(body: Node3D) -> void:
	Global.coins += 1
	print("You have ", Global.coins, " coins")
	set_collision_layer_value(3, false) # Turn layer 3 off
	set_collision_mask_value(1, false) # Turn mask 1 off
	$AnimationPlayer.play("bounce") # Play bounce animation
	if Global.coins >= Global.COINS_TO_WIN:
		Global.coins = 0
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free() # Replace with function body.

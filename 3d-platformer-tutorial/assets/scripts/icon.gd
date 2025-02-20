extends Sprite3D

var coins = 5
var player_name = "robot"
var hearts = 2.5
var SPEED = 2
var x = coins / SPEED
var key_collected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _check_inputs() -> void:
	if Input.is_action_pressed("ui_left"):
		rotate_y(deg_to_rad(-SPEED)) #takes in radians instead of degrees
	elif Input.is_action_pressed("ui_right"): 
			rotate_y(deg_to_rad(SPEED))

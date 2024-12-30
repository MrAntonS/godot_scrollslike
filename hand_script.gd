extends MeshInstance3D

var rotation_speed = 1.0
var rotation_axis = Vector3.UP

@onready var hand_node = $".."

var target_rotation = 0.0
var current_rotation = 0.0
var rotation_progress = 0.0
var is_animating = false # Flag to track if the animation is running

func _ready():
	if hand_node == null:
		printerr("Hand node not found! Please set the 'hand_node' export.")
		set_process(false)
		return

func _process(delta):
	if Input.is_action_just_pressed("Attack") and not is_animating:
		is_animating = true
		rotation_progress = 0.0 # Reset progress when starting a new animation
		current_rotation = 0.0 # Reset current rotation as well

	if is_animating:
		if rotation_progress < 90.0:
			rotation_progress += rotation_speed * delta * 500
			rotation_progress = min(rotation_progress, 90.0)

			current_rotation = rotation_progress# Always rotate from 0 to 90

			hand_node.rotation = Vector3(0, deg_to_rad(current_rotation), 0)
		else:
			# Reverse the rotation after it completes
			rotation_progress = 0.0
			current_rotation = 0.0
			hand_node.rotation = Vector3(0, 0, 0) # Reset the rotation
			is_animating = false # Stop the animation

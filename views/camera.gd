extends Node3D

# func _unhandled_input(event: InputEvent):
# 	vector
# 	if event.is_action_pressed('act_move_forward'):
# 		pass

const MIN_ZOOM := 2.0
const MAX_ZOOM := 10.0
@export var speed := 5.0

@onready var camera: Camera3D = %Camera3D
@onready var gimbal: SpringArm3D = %Gimbal

func _physics_process(delta):
	var input_dir = Input.get_vector('act_move_left', 'act_move_right', 'act_move_forward', 'act_move_backward')
	var dir = (gimbal.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# https://forum.godotengine.org/t/how-to-make-wasd-movement-match-camera/50768/2
	var tl: Vector3 = Vector3.ZERO
	# tl.x = Input.get_action_strength('act_move_forward') - Input.get_action_strength('act_move_backward')
	# tl.z = Input.get_action_strength('act_move_left') - Input.get_action_strength('act_move_right')
	tl.x = dir.x
	tl.z = dir.y
	tl.y = Input.get_action_strength('act_move_up') - Input.get_action_strength('act_move_down')
	translate(tl)

func _unhandled_input(event: InputEvent):
	# orbit
	if event is InputEventMouseMotion and Input.is_action_pressed('act_orbit'):
		gimbal.rotation.x += - event.relative.y * User.mouse_sensitivity
		gimbal.rotation.y += - event.relative.x * User.mouse_sensitivity
		gimbal.rotation_degrees.x = clampf(gimbal.rotation_degrees.x, -80, 80)

	# zoom
	if event.is_action_pressed('act_zoom_in') or event.is_action_pressed('act_zoom_out'):
		var strength = Input.get_action_strength('act_zoom_in') - Input.get_action_strength('act_zoom_out')
		gimbal.spring_length = clampf(gimbal.spring_length - strength, MIN_ZOOM, MAX_ZOOM)

	if event.is_action_pressed('act_reset_camera'):
		transform = Transform3D.IDENTITY
		global_transform = Transform3D.IDENTITY
		gimbal.transform = Transform3D.IDENTITY
		
		# position = Vector3.ZERO
		# gimbal.rotation = Vector3.ZERO
extends Node3D

# I copied this class from a tutorial
# Johnny Rouddro, Godot 4 Third Person Controller #1
@onready var yawNode = $Yaw
@onready var pitchNode = $Yaw/Pitch
@onready var camera = $Yaw/Pitch/Camera3D


var yaw : float = 0
var pitch : float = 0

var yawSensitivity : float = 0.3
var pitchSensitivity: float = 0.3

var yawAcceleration : float = 15
var pitchAcceleration : float = 15

func _input(event):

  # If the event is not mouse or not middle mouse button, don't move camera.
  if not event is InputEventMouseMotion:
    return
  if not Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
    return

  yaw += -event.relative.x * yawSensitivity
  pitch += -event.relative.y * pitchSensitivity

func _physics_process(delta : float):
  # Lerp the yaw and pitch from the mouse x and y things
  yawNode.rotation_degrees.y = lerp(yawNode.rotation_degrees.y, yaw, yawAcceleration * delta)
  pitchNode.rotation_degrees.x = lerp(pitchNode.rotation_degrees.y, pitch, pitchAcceleration * delta)

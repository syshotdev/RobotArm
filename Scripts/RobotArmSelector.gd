extends Node3D

@export var base : Node3D
@export var shoulder : RobotArmSegment
@export var elbow : RobotArmSegment
@export var wrist : RobotArmSegment
@export var claw : Node3D

var selected = null

# TODO: Find a way to call the "Move" function of a specific arm segment,
# and also send an input to ServoCommunicator.gd to call the arm to move
func _input(event):
  # Don't even try unless it's a keypress
  if not event is InputEventKey:
    return

  match event.keycode:
    KEY_0:
      selected = base
    KEY_1:
      selected = shoulder
    KEY_2:
      selected = elbow
    KEY_3:
      selected = wrist
    KEY_4:
      selected = claw




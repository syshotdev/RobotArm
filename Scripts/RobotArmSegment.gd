extends Node3D

class_name RobotArmSegment

@export var servo : Constants.ServoIndex
@export var minPosition : int = 0
@export var maxPosition : int = 1000
@export var lengthCM : int = 20 # Centimeters, in Godot meters divide by 10
#@export var rotationAxis : Vector3i

var servoPosition : int = floor(maxPosition / 2.0) : set = Move
var segment : CSGBox3D


func _ready():
  segment = $Segment
  segment.size.x = lengthCM / 10.0


func Move(newServoPosition : int):
  servoPosition = clampi(newServoPosition, minPosition, maxPosition)
  rotation.z = servoPosition


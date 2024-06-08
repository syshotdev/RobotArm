extends Node3D

class_name RobotArmSegment

@export var servo : Constants.ServoIndex
@export var minPosition : int = 0
@export var maxPosition : int = 1000
@export var minDegrees : float = 0
@export var maxDegrees : float = 180

@export var lengthCM : int = 20 # Centimeters, in Godot meters divide by 10
@export var nextArmSegment : RobotArmSegment = null
#@export var rotationAxis : Vector3i

var servoPosition : int = minPosition : set = Move
var segment : CSGBox3D


func _ready():
  segment = $Segment
  segment.size.x = lengthCM / 10.0
  # Make the base at start of last arm
  segment.position.x = -(lengthCM / (10.0 * 2))

  Move(self.servoPosition) # To update rotation

  if nextArmSegment == null:
    return

  nextArmSegment.position.x = -self.lengthCM / 10.0


func Move(newServoPosition : int):
  servoPosition = clampi(newServoPosition, minPosition, maxPosition)

  var rotationDegreesFromPositionAndDegrees = MapRange(servoPosition, minPosition, maxPosition, minDegrees, maxDegrees)

  # TODO: For robot base, make this the bottom's rotation.
  rotation.z = deg_to_rad(rotationDegreesFromPositionAndDegrees)


# A range from f1(first1) to f2 is now mapped to s1(second1) to s2,
# Example: (50, 0, 100, 100, 1000). Mapping (0 to 100) to (100 to 1000), and return what 50 would be. 
# This will return half of (1000 minus 100), being 450.
func MapRange(input, f1, f2, s1, s2) -> float:
  # https://stackoverflow.com/questions/5731863/mapping-a-numeric-range-onto-another
  var slope : float = (s1 - s2) / (f1 - f2)
  var output : float = s1 + slope * (input - f1)
  return output

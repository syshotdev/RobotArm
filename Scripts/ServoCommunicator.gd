extends Node

class_name ServoCommunicator

# A wrapper for PortCommunicator, where the sole purpose is to
# make moving servos easier to do, make sure servos don't 
# run into each other, and whatever else.

# Actually I think I'll just make a servo class... Maybe it communicates with this one IDK

# Update: This class handles all the logic for RobotArmSegment and grabs the settings from the
# segments

signal SendMessage(message : String)
signal SendCommand(servoIndex : int, position : int, ramp : int)
signal GetPortNames()

# All parts for accessing GUI arm segments (For controlling them)
@export var base : RobotArmSegment
@export var shoulder : RobotArmSegment
@export var elbow : RobotArmSegment
@export var wrist : RobotArmSegment
@export var claw : RobotArmSegment
@onready var allSegments : Array = [base, shoulder, elbow, wrist, claw]


func _ready():
  #SendMessage.emit("!SCVER?" + char(13))
  #MoveServo(Constants.ServoIndex.SHOULDER, 500, 10)
  pass


# IMPORTANT: Shoulder has 2 SERVOS, which is why it skips
func MoveServo(servo : Constants.ServoIndex, position : int, ramp : int):
  var segment := GetSegmentFromEnum(servo)
  segment.Move(position)

  SendCommand.emit(servo, position, ramp)
  if servo == Constants.shoulder:
    SendCommand.emit(2, position, ramp)


# Get a robot arm segment from the enum
func GetSegmentFromEnum(servo : Constants.ServoIndex) -> RobotArmSegment:
  # For each arm in all arm segments, check if it's the correct ServoIndex and return the arm
  for arm in allSegments:
    if arm.servo == servo:
      return arm
  return null

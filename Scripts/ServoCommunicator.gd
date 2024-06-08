extends Node

class_name ServoCommunicator

# A wrapper for PortCommunicator, where the sole purpose is to
# make moving servos easier to do, make sure servos don't 
# run into each other, and whatever else.

# Actually I think I'll just make a servo class... Maybe it communicates with this one IDK

signal SendMessage(message : String)
signal SendCommand(servoIndex : int, position : int, ramp : int)
signal GetPortNames()

func _ready():
  #SendMessage.emit("!SCVER?" + char(13))
  MoveServo(Constants.ServoIndex.SHOULDER, 500, 10)
  pass


# IMPORTANT: Shoulder has 2 SERVOS, which is why it skips
func MoveServo(servo : Constants.ServoIndex, position : int, ramp : int):
  SendCommand.emit(servo, position, ramp)
  if servo == Constants.shoulder:
    SendCommand.emit(2, position, ramp)

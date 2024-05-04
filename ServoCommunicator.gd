extends Node
# A wrapper for PortCommunicator, where the sole purpose is to
# make moving servos easier to do, make sure servos don't 
# run into each other, and whatever else.

# Actually I think I'll just make a servo class... Maybe it communicates with this one IDK

signal SendCommand(message : String)

enum ServoNames{
  BASE,
  SHOULDER,
  ELBOW,
  WRIST,
  CLAW,
}


func _ready():
  FormatCommand(0, 1200, 63)


func MoveServo(servo : ServoNames, position : int, ramp : int):
  match servo:
    ServoNames.BASE:
      FormatCommand(0, position, ramp);


func FormatCommand(servoIndex : int, position : int, ramp : int):
  # First ServoIndex, Ramp 1 byte, Position is 2 bytes
  var byteArray : PackedByteArray = [servoIndex, ramp, position, position >> 8]
  print(byteArray)

  var command := "!SC" + byteArray.hex_encode()

  """
  for byte in byteArray.hex_encode():
    var byteString = str(byte)
    byteString.pad_zeros(2)
    command += str(byteString)
  """

  command += char(13) # Carriage return
  print(command)
  SendCommand.emit(command)

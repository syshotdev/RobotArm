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
  #SendCommand.emit("!SCVER?" + char(13))
  FormatAndSendCommand(0, 0, 1)


func MoveServo(servo : ServoNames, position : int, ramp : int):
  match servo:
    ServoNames.BASE:
      FormatAndSendCommand(0, position, ramp);


func FormatAndSendCommand(servoIndex : int, position : int, ramp : int):
  var positionLowBit : int = position % 255
  var positionHighBit : int = floor(position / 255.0)
  # First ServoIndex, Ramp 1 byte, Position is 2 bytes
  var byteArray : PackedByteArray = [servoIndex, ramp, positionLowBit, positionHighBit]
  print(byteArray)

  # Translated = "!SC"
  var command : PackedByteArray = [char(33), char(83), char(67)]

  for byte in byteArray:
    if byte <= 0: # When byte is 0, doesn't add to command :(
      command.append(1)
      continue

    command.append(byte)

  command.append(13) # Carriage return

  print(command)
  SendCommand.emit(command)

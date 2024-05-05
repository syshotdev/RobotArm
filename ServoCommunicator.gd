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
  FormatAndSendCommand(0, 120, 10)


func MoveServo(servo : ServoNames, position : int, ramp : int):
  match servo:
    ServoNames.BASE:
      FormatAndSendCommand(0, position, ramp);


func FormatAndSendCommand(servoIndex : int, position : int, ramp : int):
  # First ServoIndex, Ramp 1 byte, Position is 2 bytes
  var byteArray : PackedByteArray = [servoIndex, ramp, position, position >> 8]
  print(byteArray)

  var command := "!SC" #+ byteArray.hex_encode()

  # I know this part is atrocious, only PackedByteArray has toHex,
  # and string has pad_zeros which does "9" -> "09"
  for byte in byteArray:
    var tempByteArray : PackedByteArray = [byte]
    var hexString = tempByteArray.hex_encode()
    hexString.pad_zeros(2)
    command += hexString

  command += char(13) # Carriage return
  print(command)
  SendCommand.emit(command)

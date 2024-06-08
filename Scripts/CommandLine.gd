extends Control

@export var lineEdit : LineEdit
@export var servoCommunicator : ServoCommunicator

# Start the commandline if commandline button pressed
func _input(_event):

  # If commandline pressed, make it visible
  if Input.is_action_just_pressed("COMMAND_LINE"):
   lineEdit.visible = !lineEdit.visible

  # Mouse mode depending on if commandline is visible
  if lineEdit.visible:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
  else:
    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


# When you press enter, this gets called and it sanitizes the input
func commandlineTextEntered(text : String):

  text = text.lstrip(" ").rstrip(" ")
  var tokens := text.split(" ")
  
  if tokens.size() <= 0:
    printerr("Command that you entered doesn't have anything")
    return

  # Clear the line edit so it looks like you entered the command
  lineEdit.text = "" 

  # Pop the first token and that's the command
  var command = tokens[0]
  tokens.remove_at(0)

  runCommand(command, tokens)


# Matches the right commmand and carries it out
func runCommand(command : String, tokens : PackedStringArray):
  # Match each command and run a function based on what it is
  match command.to_lower():
    "move":
      if tokens.size() != 3:
        sendLineEditError("Tokens is not 3. Format: servo, position (not degrees), ramp")
        return

      moveArm(tokens[0], tokens[1].to_int(), tokens[2].to_int())

    _:
      printerr("No command named {}", command)


func sendLineEditError(text : String):
  printerr(text)
  pass # TODO: Implement this


# TODO: Make "servoPosition" degrees rather than an arbitrary number
func moveArm(servo : String, servoPosition : int, ramp : int):
  var index : Constants.ServoIndex = Constants.ServoIndex.get(servo)
  servoCommunicator.MoveServo(index, servoPosition, ramp)

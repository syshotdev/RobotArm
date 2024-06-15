extends Control

@export var lineEdit : LineEdit
@export var servoCommunicator : ServoCommunicator
@onready var timer : Timer = $Timer # Timer that we use for callbacks and whatnot

# For history of commandline
var history := [""]
var currentHistoryIndex := 0

# Start the commandline if commandline button pressed
func _input(event):
  
  if not (event is InputEventKey):
    return

  # Commandline history
  if Input.is_action_pressed("ui_up"):
    currentHistoryIndex += 1
    currentHistoryIndex = mini(currentHistoryIndex, history.size() - 1)
    lineEdit.text = history[currentHistoryIndex]

  if Input.is_action_pressed("ui_down"):
    currentHistoryIndex -= 1
    currentHistoryIndex = maxi(currentHistoryIndex, 0)
    lineEdit.text = history[currentHistoryIndex]


  # TODO: When T pressed in-game, commandline goes away. Fix that pls by not doing that if it's focused
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

  # Append command history
  history.insert(1, text) 
  currentHistoryIndex = 0

  var tokens := text.split(" ")
  
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

    "test":
      if tokens.size() != 1:
        sendLineEditError("Tokens is not 1. Format: servo")
        return

      testArm(tokens[0])

    _:
      printerr("No command named '%s'" % command)


func sendLineEditError(text : String):
  printerr(text)
  pass # TODO: Implement this by showing on-screen error


# These are here because the lerping between servo positions requires storing variables
# for longer than one function call.
var testServoPosition : int = 0
var testTime : float = 0 # How many seconds the test has been running
var testServo : String = "NOTASERVO"
const testTimeMax : float = 120.0 # Seconds the robot will go from min to max position
const updateRateSeconds : float = 0.3 # How often to update robot arm position while testing

# This function goes from position 0 (for motors) to position ~10000 to get an estimate
# for degrees and min/max position. This will get complicated :)
func testArm(servo : String):
  testServoPosition = 0
  testTime = 0
  testServo = servo

  # Connect timeout signal
  if not timer.timeout.is_connected(moveArm):
    timer.timeout.connect(updateTestArm)

  timer.wait_time = updateRateSeconds
  timer.start()

# When you start this function, it goes in updateRate intervals till the target time has been reached
func updateTestArm():
  # If we've gone over max time for test, end it.
  if testTime > testTimeMax:
    timer.stop()
    return

  testTime += updateRateSeconds
  testServoPosition = lerp(0, 3000, testTime / testTimeMax) # From 0 to () servo position

  moveArm(testServo, testServoPosition, 1) # Move the servo to servo position at 1 ramp (very fast)
  #print("Moving arm to position ", testServoPosition)

  timer.start()


# TODO: Make "servoPosition" degrees rather than an arbitrary number
# TODO: If you input a command incorrectly (Give number instead of string for ServoIndex.get)
# you shouldn't crash but be given an error
func moveArm(servo : String, servoPosition : int, ramp : int):
  # This should really be an "Option" type from Rust. So sad Godot doesn't support that
  if Constants.ServoIndex.get(servo.to_upper()) == null:
    sendLineEditError("First argument should be a string of a known servo. Ex: base")
    return

  var index : Constants.ServoIndex = Constants.ServoIndex.get(servo.to_upper())
  servoCommunicator.MoveServo(index, servoPosition, ramp)

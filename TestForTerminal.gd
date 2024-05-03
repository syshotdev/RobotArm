extends Node3D

signal sendMessage(message: String)
# Called when the node enters the scene tree for the first time.
func _ready():
	var message = OS.read_string_from_stdin()
	#sendMessage.emit("!SCVER\r")
	sendMessage.emit("!SCVER?\r")
	

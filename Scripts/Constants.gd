extends Node

class_name Constants

# IMPORTANT: Shoulder has 2 SERVOS, which is why it skips
enum ServoIndex{
  BASE = 0,
  SHOULDER = 1,
  ELBOW = 3,
  WRIST = 4,
  CLAW = 5,
}

const base = ServoIndex.BASE
const shoulder = ServoIndex.SHOULDER
const elbow = ServoIndex.ELBOW
const wrist = ServoIndex.WRIST
const claw  = ServoIndex.CLAW

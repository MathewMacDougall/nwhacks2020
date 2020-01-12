extends Node2D

export (PackedScene) var object

export var direction = Vector2(1, 1)
export var min_linear_speed = 10
export var max_linear_speed = 500
export var min_angular_speed_deg = -360
export var max_angular_speed_deg = 360
export var interval_seconds = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()
    $SpawnTimer.start(interval_seconds)

func _on_SpawnTimer_timeout():
    var o = object.instance()
    add_child(o)
    var linear_magnitude = rand_range(min_linear_speed, max_linear_speed)
    var angular_magnitude = rand_range(min_angular_speed_deg, max_angular_speed_deg)
    o.linear_velocity = direction.normalized() * linear_magnitude
    o.angular_velocity = deg2rad(angular_magnitude)
    

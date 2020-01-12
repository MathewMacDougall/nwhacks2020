extends Node2D

#var JunkBox = preload("res://JunkBoxScene.tscn")
export (PackedScene) var object

export var direction = Vector2(1, 1)
export var min_speed = 10
export var max_speed = 500
export var interval_seconds = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()
    $SpawnTimer.start(interval_seconds)

func _on_SpawnTimer_timeout():
    var o = object.instance()
    add_child(o)
    var magnitude = rand_range(min_speed, max_speed)
    o.linear_velocity = direction.normalized() * magnitude

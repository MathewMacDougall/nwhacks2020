extends Node2D
class_name LaserReceiver

export var cooldown_seconds = 0.25

var ready = true
var normal_light_energy = null

signal laser_detected

# Called when the node enters the scene tree for the first time.
func _ready():
    normal_light_energy = $Light2D.energy


func receive_laser():
    if ready:
        ready = false
        emit_signal("laser_detected")
        $Light2D.energy = 0.0
        yield(get_tree().create_timer(cooldown_seconds), "timeout")
        $Light2D.energy = normal_light_energy
        ready = true
        print("laser detected")

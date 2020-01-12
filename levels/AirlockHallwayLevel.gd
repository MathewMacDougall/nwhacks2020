extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Airlock1Receiver_laser_detected():
    $Airlock1.open_or_close()


func _on_Airlock2Receiver_laser_detected():
    $Airlock2.open_or_close()


func _on_Airlock1_opened():
    $Airlock1Gravity.enable()


func _on_Airlock1_closed():
    $Airlock1Gravity.disable()


func _on_Airlock2_opened():
    $Airlock2Gravity.enable()


func _on_Airlock2_closed():
    $Airlock2Gravity.disable()

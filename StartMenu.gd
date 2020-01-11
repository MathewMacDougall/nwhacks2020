extends Control

var current_x = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    pass
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var rot_speed = 0.1
    current_x = current_x + 0.01
    $StationSmall.rotation = $StationSmall.rotation + rot_speed * delta
    $StationSmall.translate(Vector2(0, 0.1*sin(current_x)))
    

func _on_StartButton_pressed():
    get_tree().change_scene("levels/TestLevel.tscn")

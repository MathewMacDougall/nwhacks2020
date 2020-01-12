extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

func _on_Visibility_screen_exited():
    queue_free()

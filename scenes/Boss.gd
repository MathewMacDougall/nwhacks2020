extends Node2D

signal next_level

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_EvilComputer_body_entered(body):
    emit_signal("next_level")

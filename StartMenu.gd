extends Control

signal next_level
signal play_music(path)

var current_x = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    emit_signal("play_music", "assets/music/StartMenu.ogg")
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var rot_speed = 0.1
    current_x = current_x + 0.01
    $StationSmall.rotation = $StationSmall.rotation + rot_speed * delta
    $StationSmall.translate(Vector2(0, 0.1*sin(current_x)))
    

func _on_StartButton_pressed():
    $InitialScene.play("start_game")

func _on_InitialScene_animation_finished(anim_name):
    emit_signal("play_music", "assets/music/Initial.ogg")
    emit_signal("next_level")


func _on_Credit_pressed():
    $MainMenu.visible = false
    $CreditMenu.visible = true


func _on_Back_pressed():
    $MainMenu.visible = true
    $CreditMenu.visible = false

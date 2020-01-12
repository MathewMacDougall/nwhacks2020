extends Node2D

signal kill_player
signal next_level

var window_bounds

# Called when the node enters the scene tree for the first time.
func _ready():
    connect("kill_player", $Player, "_on_kill_player")
    set_camera_limits()
    
func _process(delta):
    window_bounds = get_viewport().size
    
    if check_player_out_of_bounds():
        emit_signal("kill_player")

func set_camera_limits():
    var map_limits = $Environment.get_used_rect()
    var map_cellsize = $Environment.cell_size
    $Player/Camera.limit_left = map_limits.position.x * map_cellsize.x * 2
    $Player/Camera.limit_right = map_limits.end.x * map_cellsize.x * 2
    $Player/Camera.limit_top = map_limits.position.y * map_cellsize.y * 2
    $Player/Camera.limit_bottom = map_limits.end.y * map_cellsize.y * 2
    
func check_player_out_of_bounds():
    var player_position = $Player.get_global_transform_with_canvas().origin
    if player_position.y < 0 or player_position.y > window_bounds.y:
        return true

func _on_LaserReceiver_laser_detected():
    $AirlockDoor.open_or_close()


func _on_HallwayDoorLaserReceiver_laser_detected():
    $HallwayDoor.open_or_close()

func _on_AirlockDoor_opened():
    $Gravity.enable()
    
func _on_AirlockDoor_closed():
    $Gravity.disable()


func _on_next_stage_body_entered(body):
    emit_signal("next_level")

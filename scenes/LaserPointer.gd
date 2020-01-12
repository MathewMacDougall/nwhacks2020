extends Node2D

signal shoot_laser_start
signal shoot_laser_end

export var laser_ignore = []

var hit = null
var beam_duration = 0.2
var beam_cooldown = 0.5
var can_shoot = true;
var objects_ignore_laser_collision = [self]

# Called when the node enters the scene tree for the first time.
func _ready():
    # Hides the laser line by removing the second point
    $Line2D.remove_point(1)
    objects_ignore_laser_collision.append(laser_ignore)
    
func _process(delta):
    # orient the laser pointer towards the mouse
    var beam_origin = self.get_global_transform().xform($Line2D.get_point_position(0))
    var beam_vector = (get_global_mouse_position() - beam_origin).normalized() * 10000
    
    if hit:
        hit = cast_beam()
        

# This is called on mouse/keyboard events
func _input(event):
    if(event is InputEventMouseButton):
        if(event.is_pressed() and event.button_index == BUTTON_RIGHT):
            shoot()

func shoot():
    if can_shoot:
        $LaserSoundEffect.play()
        can_shoot = false
        hit = cast_beam()
        emit_signal("shoot_laser_start")
        yield(get_tree().create_timer(beam_duration), "timeout")
        if $Line2D.points.size() > 1:
            $Line2D.remove_point(1)
        hit = null
        $LaserSoundEffect.stop()
        emit_signal("shoot_laser_end")
        yield(get_tree().create_timer(beam_cooldown), "timeout")
        can_shoot = true
    
    
func cast_beam():
    var beam_origin = self.get_global_transform().xform($Line2D.get_point_position(0))
    var beam_vector = (get_global_mouse_position() - beam_origin).normalized() * 10000
    var space_state = get_world_2d().direct_space_state
    var result = space_state.intersect_ray(beam_origin, beam_origin + beam_vector, laser_ignore)
    var beam_end = null
    if(result):
        beam_end = result.position
        if result.collider is LaserReceiver:
            result.collider.receive_laser()
    else:
        beam_end = beam_origin + beam_vector
        
    beam_end = self.get_global_transform().xform_inv(beam_end)
        
    if !hit:
        $Line2D.add_point(beam_end)
    else:
        $Line2D.set_point_position(1, beam_end)
        
    return beam_end
extends RigidBody2D

var initial_player_position

# Max speed of the player (pixels/sec)
export var speed = 400

# The direction the player wants to jump in
var desired_jump_direction = false

# TODO: delete this
# Whether or not this player is currently on a wall
var on_a_wall = true

# The joint holding the player to something
var player_holding_joint = false

var player_killed = false
var laser_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
    initial_player_position = position

    $LaserPointer.laser_ignore.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    # Perform a jump if one is set
    if desired_jump_direction:
        linear_velocity = desired_jump_direction.normalized() * speed
        angular_velocity = 0
        if linear_velocity.x < 0:
            rotation = linear_velocity.angle() + PI
        else:
            rotation = fmod(linear_velocity.angle(), PI)
        desired_jump_direction = false
        
    select_player_sprite()
    
# This is called on mouse/keyboard events
func _input(event):
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
        if player_holding_joint:
            player_holding_joint.free()
            player_holding_joint = false
            # Let the player jump in the direction of the click
        # TODO: indent this line by 1
        desired_jump_direction = get_global_mouse_position() - position
        
func _integrate_forces(state): 
    for i in range(get_colliding_bodies().size()):
        var collision_position = state.get_contact_local_position(i)
        var colliding_body = get_colliding_bodies()[i]
        
        if colliding_body is Ladder && !player_holding_joint:
            player_holding_joint = PinJoint2D.new()
            player_holding_joint.disable_collision = false
            player_holding_joint.position = position
            player_holding_joint.set_name("player_holding_joint")
            player_holding_joint.softness = 0
            player_holding_joint.set_node_a("../" + get_parent().get_path_to(self))
            player_holding_joint.set_node_b("../" + get_parent().get_path_to(colliding_body))
            get_parent().call_deferred("add_child", player_holding_joint)
            
func select_player_sprite():
    # Determine sprite to draw
    if not player_killed:
        if laser_active:
            $Sprite.frame = 6
        elif player_holding_joint:
            $Sprite.frame = 11
        elif linear_velocity.x < 0:
            $Sprite.frame = 9
        else:
            $Sprite.frame = 8

func _on_kill_player():
    linear_velocity = Vector2()
    angular_velocity = 0
    player_killed = true
    $DeathAnimate.play("in")

func _on_DeathAnimate_animation_finished(anim_name):
    if anim_name == "in":
        position = initial_player_position
        desired_jump_direction = false
        rotation = 0
        $DeathAnimate.play("out")
    elif anim_name == "out":
        player_killed = false

func _on_LaserPointer_shoot_laser_start():
    laser_active = true


func _on_LaserPointer_shoot_laser_end():
    laser_active = false

extends RigidBody2D

var initial_player_position

# Max speed of the player (pixels/sec)
export var speed = 400

# Ladder timeout (time we ignore ladders when leaving one, in seconds)
export var ladder_timeout = 0.2

export var laser_normal_position = Vector2()
export var laser_non_normal_position = Vector2()

# The direction the player wants to jump in
var desired_jump_direction = false

# Timer used to prevent extra sticking to ladders when jumping off them
var ignore_ladders_timer = 0

# The joint holding the player to something
var player_holding_joint = false

# Sprite texture flags
var player_normal_direction = true
var player_killed = false
var laser_active = false

# The max crawl speed (ie. if the player is crawling on a wall)
var max_abs_crawl_speed = 100

# The current crawl speed
var current_crawl_speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    initial_player_position = position

    $LaserPointer.laser_ignore.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    # Decrease ladder ignore timeout if active
    if ignore_ladders_timer > 0:
        ignore_ladders_timer -= delta
    
    # Perform a jump if one is set
    if desired_jump_direction:
        linear_velocity = desired_jump_direction.normalized() * speed
        angular_velocity = 0
        if linear_velocity.x < 0:
            rotation = linear_velocity.angle() + PI
        else:
            rotation = fmod(linear_velocity.angle(), PI)
        desired_jump_direction = false
    else:
        desired_jump_direction = false
    
    # If holding a joint, determine the angle to take
    if player_holding_joint:
        var wall_to_crawl_along = player_holding_joint.get_node(player_holding_joint.node_b)
        player_normal_direction = abs(wall_to_crawl_along.rotation) < PI / 2
        rotation = wall_to_crawl_along.rotation if player_normal_direction else PI + wall_to_crawl_along.rotation 
        angular_velocity = 0
        
        # Determine crawl angle if necessary
        if abs(current_crawl_speed) > 0:
            # We need to remove the joint to update the position
            var joint_player_path = player_holding_joint.node_a
            player_holding_joint.node_a = ""
            var wall_rotation = rotation - PI/2
            var position_update_vector = Vector2(cos(wall_rotation), sin(wall_rotation))
            position_update_vector = position_update_vector.normalized() * current_crawl_speed * delta
            position += position_update_vector
            player_holding_joint.node_a = joint_player_path

    select_player_sprite()
    place_laser_origin()
    
# This is called on mouse/keyboard events
func _input(event):
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and !event.pressed:
        # If we're on a wall, remove the joint holding us there and jump!
        if player_holding_joint:
            desired_jump_direction = get_global_mouse_position() - position
            remove_holding_joint()
    elif event is InputEventKey:
        # Handle crawling if we're on a wall
        if player_holding_joint:
            if Input.is_action_pressed("ui_up"):
                current_crawl_speed = max_abs_crawl_speed
            elif Input.is_action_pressed("ui_down"):
                current_crawl_speed = -max_abs_crawl_speed
            else:
                current_crawl_speed = 0
        else:
            current_crawl_speed = 0
            
        if event.scancode == KEY_R:
            _on_kill_player()
        
        
func _integrate_forces(state): 
    for i in range(get_colliding_bodies().size()):
        var collision_position = state.get_contact_local_position(i)
        var colliding_body = get_colliding_bodies()[i]
        
        if colliding_body is Ladder && !player_holding_joint && ignore_ladders_timer <= 0:
            player_holding_joint = PinJoint2D.new()
            player_holding_joint.disable_collision = false
            player_holding_joint.position = position
            player_holding_joint.set_name("player_holding_joint")
            player_holding_joint.softness = 0
            player_holding_joint.set_node_a("../" + get_parent().get_path_to(self))
            player_holding_joint.set_node_b("../" + get_parent().get_path_to(colliding_body))
            get_parent().call_deferred("add_child", player_holding_joint)
            
            linear_velocity = Vector2()
               
func select_player_sprite():
    # Determine sprite to draw
    if not player_killed:
        if player_holding_joint:
            if laser_active:
                $Sprite.frame = 16 if player_normal_direction else 17
            else:
                $Sprite.frame = 10 if player_normal_direction else 11
        else:
            player_normal_direction = linear_velocity.x >= 0
            if laser_active:
                $Sprite.frame = 6 if player_normal_direction else 7
            else:
                $Sprite.frame = 8 if player_normal_direction else 9
                
func place_laser_origin():
    $LaserPointer.position = laser_normal_position if player_normal_direction else laser_non_normal_position

func _on_kill_player():
    linear_velocity = Vector2()
    angular_velocity = 0
    gravity_scale = 0
    remove_holding_joint()
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
        gravity_scale = 1

func _on_LaserPointer_shoot_laser_start():
    laser_active = true


func _on_LaserPointer_shoot_laser_end():
    laser_active = false

func remove_holding_joint():
    if(player_holding_joint):
        player_holding_joint.free()
        ignore_ladders_timer = ladder_timeout

    player_holding_joint = false
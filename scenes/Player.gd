extends RigidBody2D

var initial_player_position

# Max speed of the player (pixels/sec)
export var speed = 400

# The direction the player wants to jump in
var desired_jump_direction = false

# Whether or not this player is currently on a wall
var on_a_wall = true

# The current velocity of the user
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
    initial_player_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    # Perform a jump if one is set
    if desired_jump_direction:
        # Move the player in the direction they want to go
        velocity = desired_jump_direction.normalized()*speed
        linear_velocity = desired_jump_direction.normalized() * speed
        desired_jump_direction = false
        
    # Determine sprite to draw
    if velocity.x < 0:
        $Sprite.frame = 9
    else:
        $Sprite.frame = 8
    
# This is called on mouse/keyboard events
func _input(event):
    if event is InputEventMouseButton:
        if on_a_wall:
            # Let the player jump in the direction of the click
            desired_jump_direction = get_global_mouse_position() - position

func _on_player_body_entered(body):
    linear_velocity = Vector2()
    angular_velocity = 0


func _on_player_body_shape_entered(body_id, body, body_shape, local_shape):
    linear_velocity = Vector2()
    angular_velocity = 0
    pass # Replace with function body.
    
func _on_kill_player():
    position = initial_player_position
    linear_velocity = Vector2()
    angular_velocity = 0
    rotation = 0
    desired_jump_direction = false

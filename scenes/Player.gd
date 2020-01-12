extends KinematicBody2D

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
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    #    # Figure out the player velocity
    #    var velocity = Vector2()
    #    if Input.is_action_pressed("ui_right"):
    #        velocity.x += 1
    #    if Input.is_action_pressed("ui_left"):
    #        velocity.x -= 1
    #    if Input.is_action_pressed("ui_up"):
    #        velocity.y -= 1
    #    if Input.is_action_pressed("ui_down"):
    #        velocity.y += 1
    #    if velocity.length() > 0:
    #        velocity = velocity.normalized() * speed
    #        $AnimatedSprite.play()
    #    else:
    #        $AnimatedSprite.stop()
    #
    #    # Choose the animation based on the velocity direction
    #    if velocity.x != 0:
    #        # TODO: right animation
    #        #$AnimatedSprite.animation = "right"
    #        $AnimatedSprite.flip_v = false
    #        $AnimatedSprite.flip_h = velocity.x < 0
    #    elif velocity.y != 0:
    #        # TODO: up/down animation
    #        #$AnimatedSprite.animation = "up"
    #        $AnimatedSprite.flip_v = velocity.y > 0
    
    # Only permit user control if we're on a wall
    if on_a_wall and desired_jump_direction:
        # Move the player in the direction they want to go
        velocity = desired_jump_direction.normalized()*speed
    var collision = move_and_collide(velocity*delta)
    if velocity.length() > 0:
        if collision:
            on_a_wall = true
            velocity = Vector2()
            desired_jump_direction = false
        else:
            on_a_wall = false
    
# This is called on mouse/keyboard events
func _input(event):
    if event is InputEventMouseButton:
        if on_a_wall:
            # Let the player jump in the direction of the click
            desired_jump_direction = event.position - position
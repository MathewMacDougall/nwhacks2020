extends KinematicBody2D

# Speed of the player (pixes/sec)
export var speed = 400
# Size of the game window
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    # Figure out the player velocity
    var velocity = Vector2()
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        $AnimatedSprite.play()
    else:
        $AnimatedSprite.stop()
        
    # Choose the animation based on the velocity direction
    if velocity.x != 0:
        # TODO: right animation
        #$AnimatedSprite.animation = "right"
        $AnimatedSprite.flip_v = false
        $AnimatedSprite.flip_h = velocity.x < 0
    elif velocity.y != 0:
        # TODO: up/down animation
        #$AnimatedSprite.animation = "up"
        $AnimatedSprite.flip_v = velocity.y > 0
        
    velocity *= delta
        
    # Update player position based on the velocity
    move_and_collide(velocity)
        
    
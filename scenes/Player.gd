extends RigidBody2D

export(NodePath) onready var tilemap = get_node(tilemap)

# Max speed of the player (pixels/sec)
export var speed = 400

# The direction the player wants to jump in
var desired_jump_direction = false

# TODO: delete this
# Whether or not this player is currently on a wall
var on_a_wall = true

# The joint holding the player to something
var player_holding_joint = false

# The current velocity of the user
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
    
    player_holding_joint = PinJoint2D.new()
    player_holding_joint.set_name("ladder_joint")

    var player = get_parent().get_node("Player")
    var ladders = get_parent().get_node("Ladders")
    player_holding_joint.softness = 0
    player_holding_joint.set_node_a("../Player")
    player_holding_joint.set_node_b("../Ladders")
    
#    add_child(player_holding_joint)
    get_parent().call_deferred("add_child", player_holding_joint)
  
    assert(tilemap != null)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    # Perform a jump if one is set
    if desired_jump_direction:
        # Move the player in the direction they want to go
        velocity = desired_jump_direction.normalized()*speed
        linear_velocity = desired_jump_direction.normalized() * speed
        desired_jump_direction = false
    
# This is called on mouse/keyboard events
func _input(event):
    if event is InputEventMouseButton:
        if on_a_wall:
            # Let the player jump in the direction of the click
            desired_jump_direction = event.position - position
        
func _integrate_forces(state): 
    for i in range(get_colliding_bodies().size()):
        var collision_position = state.get_contact_local_position(i)
        var colliding_body = get_colliding_bodies()[i]
        var tile_pos = tilemap.world_to_map(collision_position/2)
        var tile_id = tilemap.get_cellv(tile_pos)
        var tile_name = tilemap.get_tileset().tile_get_name(tile_id)
        if colliding_body.name == "Ladders":
#            player_holding_joint = PinJoint2D.new()
#            player_holding_joint.position = collision_position
#            player_holding_joint.softness = 0
#            player_holding_joint.set_node_a(colliding_body.get_path())
#            player_holding_joint.set_node_b(self.get_path())
            pass;
#        if tile_name == "ladder":
#            # Lock the player to the object we collided with
#            player_holding_joint = PinJoint2D.new()
#            player_holding_joint.position = collision_position
##            player_holding_joint.softness = 0
#            player_holding_joint.set_node_a(colliding_body.get_path())
#            player_holding_joint.set_node_b(self.get_path())
#            pass
            # Cancel out any velocity in the direction of the ladder
#            var direction_of_collision = collision_position - position
#            var a= linear_velocity
#            var angle = direction_of_collision.angle_to(velocity)
#            pass;
                
        
    

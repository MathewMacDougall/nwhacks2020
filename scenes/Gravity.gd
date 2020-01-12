extends Area2D

export var initially_enabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
    if get_node("Position2D"):
        self.gravity_vec = get_node("Position2D").position
        self.gravity_point = true
    else:
        self.gravity_point = false
        
    if initially_enabled:
        enable()
    else:
        disable()

func enable():
    self.space_override = self.SPACE_OVERRIDE_COMBINE
    print("ENABLING GRAVITY")
    print("vec: ", self.gravity_vec)
    print("grav: ", self.gravity)
    print("point: ", self.gravity_point)
    print("space override: ", self.space_override)
    
    
func disable():
    self.space_override = self.SPACE_OVERRIDE_DISABLED
    print("DISABLING GRAVITY")
    print("vec: ", self.gravity_vec)
    print("grav: ", self.gravity)
    print("point: ", self.gravity_point)
    print("space override: ", self.space_override)
    

extends Control

var current_x = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    var tex = ImageTexture.new()
    var img = Image.new()
    img.load("assets/art/cursor.png")
    tex.create_from_image(img)
    Input.set_custom_mouse_cursor(tex)
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var rot_speed = 0.1
    current_x = current_x + 0.01
    $StationSmall.rotation = $StationSmall.rotation + rot_speed * delta
    $StationSmall.translate(Vector2(0, 0.1*sin(current_x)))
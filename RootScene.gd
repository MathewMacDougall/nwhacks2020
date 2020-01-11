extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    var tex = ImageTexture.new()
    var img = Image.new()
    img.load("assets/art/cursor.png")
    tex.create_from_image(img)
    Input.set_custom_mouse_cursor(tex)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

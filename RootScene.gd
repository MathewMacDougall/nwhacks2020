extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
    load_custom_cursor()

func load_custom_cursor():
    var tex = ImageTexture.new()
    var img = Image.new()
    img.load("assets/art/cursor.png")
    tex.create_from_image(img)
    Input.set_custom_mouse_cursor(tex)
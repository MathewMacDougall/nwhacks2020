extends Node

var current_level_index = -1
var current_level = null
var level_paths = [
    "levels/Level1.tscn",
    "levels/AirlockHallwayLevel.tscn"
]

# Called when the node enters the scene tree for the first time.
func _ready():    
    current_level = $StartMenu
    current_level.connect("next_level", self, "_on_next_level")
    current_level.connect("play_music", self, "_on_play_music")
    
    load_custom_cursor()

func load_custom_cursor():
    var tex = ImageTexture.new()
    var img = Image.new()
    img.load("assets/art/cursor.png")
    tex.create_from_image(img)
    Input.set_custom_mouse_cursor(tex)
    
func _on_play_music(path):
    $Music.stream = load(path)
    $Music.play() 

func _on_next_level():
    if current_level != null:
        remove_child(current_level)
        current_level.call_deferred("free")
    
    current_level_index += 1
    
    # Add the next level
    var next_level_resource = load(level_paths[current_level_index])
    current_level = next_level_resource.instance()
    
    current_level.connect("next_level", self, "_on_next_level")
    current_level.connect("play_music", self, "_on_play_music")
    
    add_child(current_level)

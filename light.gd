extends StaticBody2D

var player_touching = false
var has_been_lit = false
var lit = false
var can_light = true

@export var burn_time = 1
@export var num_of_lights = 2

@onready var game_man = get_parent().get_node("game_manager")

func _ready():
	$Timer.wait_time = burn_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_touching == true and Input.is_action_pressed("ui_accept"):
		lit = true
		
	if lit == true and can_light == true:
		light()
		
	if game_man.num_lit >= num_of_lights and game_man.won == false:
		win()

func win():
	print("you win!")
	game_man.won = true
	change_level()
	
func change_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1

	var next_level_path = "res://level" + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
	
func light():
	
	$Timer.start()
	print("lit")
	$lit.visible = true
	$unlit.visible = false
	game_man.num_lit += 1
	can_light = false
	
func unlight():
	game_man.num_lit -= 1
	$lit.visible = false
	$unlit.visible = true
	can_light = true
	lit = false
	
func _on_area_2d_body_entered(_player: CharacterBody2D):
	player_touching = true


func _on_area_2d_body_exited(_player: CharacterBody2D):
	player_touching = false


func _on_timer_timeout():
	unlight()

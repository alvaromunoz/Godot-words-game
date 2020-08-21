extends CenterContainer

func _ready():
	$VBoxContainer/Score.text = "Score: " + SceneSwitcher.get_param("score")

func _on_Button_pressed():
	SceneSwitcher.change_scene("res://Scenes/StartScreen.tscn", {})
	pass # Replace with function body.

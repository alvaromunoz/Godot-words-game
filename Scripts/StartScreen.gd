extends CenterContainer

func _ready():
	#https://github.com/dwyl/english-words/
	$VBoxContainer/Language.add_item("en.txt")
	#https://github.com/JorgeDuenasLerin/diccionario-espanol-txt
	$VBoxContainer/Language.add_item("es.txt")

func _on_Button_pressed():
	SceneSwitcher.change_scene("res://Scenes/Main.tscn", {
		"dictionary": $VBoxContainer/Language.get_item_text($VBoxContainer/Language.get_selected_id())
		})
	pass # Replace with function body.

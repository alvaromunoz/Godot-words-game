extends Node

const word_spawn_time = 3 #seconds
var word_timer = 0

var word_scene = preload("res://WordScene.tscn")

var dictionary = []

func _ready():
	$Keyboard.grab_focus()
	
	var file = File.new()
	if file.open("res://Dictionaries/es.txt", File.READ) != 0:
		print("Error opening file")
	while !file.eof_reached():
		var line = file.get_line()
		dictionary.append(line)
	file.close()

func _process(delta):
	word_timer += delta
	if word_timer > word_spawn_time:
		word_timer = 0
		spawn_word()

func spawn_word():
	var rtl = word_scene.instance()
	rtl.set_text(dictionary[randi() % dictionary.size()])
	rtl.rect_position.y = -100
	rtl.rect_position.x = rand_range(0,get_viewport().size.x - rtl.get_rect().size.x)
	rtl.line_explode = Vector2(-1,$Line2D.get_point_position(0).y)
	rtl.speed = 25
	$Words.add_child(rtl)

func _on_Keyboard_text_changed():
	var keyboard = $Keyboard
	var keyboard_word = keyboard.get_line(0)
	var delete_words = false
	
	if keyboard.get_line_count() > 1:
		keyboard.set_text("")
		delete_words = true
	
	for word in $Words.get_children():
		var word_start = word.get_text().substr(0, keyboard_word.length())
		var word_end = word.get_text().substr(keyboard_word.length(), -1)
		if word_start == keyboard_word:
			word.set_bbcode("[b][shake rate=25 level=10]" + word_start + "[/shake][/b]" + word_end)
			if word_end.length() == 0:
				word.set_bbcode("[rainbow freq=1 sat=1 val=1][b][shake rate=25 level=10]"+word_start+"[/shake][/b][/rainbow]")
				if delete_words:
					destroy(word)
		else:
			word.set_bbcode(word.get_text())
				
func destroy(word):
	word.explode()

extends Node

const STORE_FILE = "user://store.ini"
const STORE_SECTION = "nakama"
const STORE_KEY = "session"

const word_spawn_time = 1 #seconds
var word_timer = word_spawn_time
var game_timer = 30
var total_timer = 0

var word_scene = preload("res://Scenes/WordScene.tscn")

var dictionary = []

var session : NakamaSession = null
onready var client := Nakama.create_client("defaultkey", "127.0.0.1", 7350, "http")

func _ready():
	$Keyboard.grab_focus()
	
	var file = File.new()
	print(SceneSwitcher.get_param("dictionary"))
	if file.open("res://Dictionaries/" + SceneSwitcher.get_param("dictionary"), File.READ) != 0:
		print("Error opening file")
	while !file.eof_reached():
		var line = file.get_line()
		dictionary.append(line)
	file.close()
	
#	var cfg = ConfigFile.new()
#	cfg.load(STORE_FILE)
#	var token = cfg.get_value(STORE_SECTION, STORE_KEY, "")
#	if token:
#		var restored_session = NakamaClient.restore_session(token)
#		if restored_session.valid and not restored_session.expired:
#			session = restored_session
#			return
#	var deviceid = OS.get_unique_id() # This is not supported by Godot in HTML5, use a different way to generate an id, or a different authentication option.
#	session = yield(client.authenticate_device_async(deviceid), "completed")
#	if not session.is_exception():
#		cfg.set_value(STORE_SECTION, STORE_KEY, session.token)
#		cfg.save(STORE_FILE)
#	print(session._to_string())

func _process(delta):
	total_timer += delta
	
	word_timer += delta
	if word_timer > word_spawn_time:
		word_timer = 0
		spawn_word()
	
	game_timer -= delta
	$"Timer label".text = "Timer: " + str(int(game_timer))
	if game_timer <= 0:
		SceneSwitcher.change_scene("res://Scenes/GameOver.tscn", {"score": str(int(total_timer))})

func spawn_word():
	var rtl = word_scene.instance()
	randomize()
	rtl.set_text(dictionary[randi() % dictionary.size()])
	rtl.rect_position.y = -10
	rtl.rect_position.x = rand_range(0,get_viewport().size.x - rtl.get_rect().size.x)
	rtl.line_explode = $Line2D.get_point_position(0).y
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
		if word_start.nocasecmp_to(keyboard_word) == 0:
			word.set_bbcode("[b][shake rate=25 level=10]" + word_start + "[/shake][/b]" + word_end)
			if word_end.length() == 0:
				word.set_bbcode("[rainbow freq=1 sat=1 val=1]"+word.get_bbcode()+"[/rainbow]")
				if delete_words:
					destroy(word)
		else:
			word.set_bbcode(word.get_text())

func destroy(word):
	game_timer += word_timescore(word.get_text())
	word.explode()

func word_timescore(text):
	return int(text.length()/3)

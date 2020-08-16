extends RichTextLabel

var speed = 0

var line_explode = Vector2(0, 0)

func _process(delta):
	self.rect_position.y += speed * delta
	if line_explode.x == -1:
		#check y
		if self.rect_position.y > line_explode.y:
			self.explode()
	else:
		#check x
		if self.rect_position.x > line_explode.x:
			self.explode()

func explode():
	self.queue_free()

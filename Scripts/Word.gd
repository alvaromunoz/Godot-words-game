extends RichTextLabel

var speed = 0

var line_explode = 0

func _process(delta):
	self.rect_position.y += speed * delta
	if self.rect_position.y > line_explode:
		self.explode()

func explode():
	self.queue_free()

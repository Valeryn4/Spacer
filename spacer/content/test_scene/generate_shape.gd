extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var max_pixel: int = 0
	var sprites: Array[Sprite2D] = []
	for node in get_children() :
		var sprite := node as Sprite2D
		if sprite :
			sprites.append(sprite)
			var rect := sprite.get_rect()
			var a := maxi(rect.size.x, rect.size.y)
			var l := ceili(sprite.position.length())
			var pixel_pos :=  a + l
			if max_pixel < pixel_pos :
				max_pixel = pixel_pos
	
	var image := Image.create(max_pixel, max_pixel, false, Image.FORMAT_RGBA8)
	image.resize_to_po2(true)
	image.fill(Color(1.0, 1.0, 1.0, 0.0))
	
	image.
	
	var test_node := Sprite2D.new()
	var test_texture := ImageTexture.create_from_image(image)
	test_node.texture = test_texture
	add_child(test_node)
	move_child(test_node, 0)
	
	#image.create()
	#var bit_map := BitMap.new()
	

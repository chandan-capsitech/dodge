extends Area2D
signal hit

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	# keyboard input
	if Input.is_action_pressed("move_right"):
		velocity.x += 2
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	#mouse input
	if velocity == Vector2.ZERO and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var target = get_global_mouse_position()
		if position.distance_to(target) > 10:
			velocity = (target - position).normalized()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = &"walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = &"up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func start(pos):
	position = pos
	rotation = 0
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(_body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred(&"disabled", true)

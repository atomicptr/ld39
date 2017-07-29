extends KinematicBody2D

onready var top_sprite = get_node("TopSprite")
onready var bottom_sprite = get_node("BottomSprite")

const ACCELERATION = 6.0
const TURN_RATE = 0.05

var velocity = Vector2(0, 0)
var direction = Vector2(0, 1)

func _ready():
    set_process(true)

func _process(delta):
    update_top_sprite(delta)

    if Input.is_action_pressed("forward"):
        velocity += (direction * ACCELERATION)

    if Input.is_action_pressed("backward"):
        velocity -= (direction * ACCELERATION) * 0.5

    if Input.is_action_pressed("turn_left"):
        turn(-TURN_RATE)

    if Input.is_action_pressed("turn_right"):
        turn(TURN_RATE)

    bottom_sprite.look_at(get_pos() + direction)

    move(velocity * delta)
    velocity *= 0.9

    print(direction)

func turn(rad):
    var sinus = sin(rad)
    var cosinus = cos(rad)

    var tx = direction.x
    var ty = direction.y

    direction.x = (cosinus * tx) - (sinus * ty)
    direction.y = (sinus * tx) + (cosinus * ty)

func update_top_sprite(delta):
    top_sprite.look_at(get_viewport().get_mouse_pos())
extends Area2D

const BULLET_SPEED = 150.0

var direction = Vector2(0, -1)

func _ready():
    set_process(true)

func _process(delta):
    move(direction * BULLET_SPEED * delta)

func move(vec):
    set_pos(get_pos() + vec)

func set_direction(dir):
    direction = dir.normalized()
    look_at(get_global_pos() - (direction * 2))

func _on_bullet_body_enter(body):
    if body.is_in_group("enemy"):
        queue_free()
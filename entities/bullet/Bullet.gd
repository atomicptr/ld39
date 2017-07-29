extends Area2D

const BULLET_SPEED = 150.0

var direction = Vector2(0, -1)

var owner = null

func _ready():
    set_process(true)

func _process(delta):
    move(direction * BULLET_SPEED * delta)

func set_owner(owner):
    self.owner = owner

func move(vec):
    set_pos(get_pos() + vec)

func set_direction(dir):
    direction = dir.normalized()
    look_at(get_global_pos() - (direction * 2))

func _on_bullet_body_enter(body):
    if body.is_in_group("hittable"):
        if owner == null or (owner != null and owner.get_instance_ID() != body.get_instance_ID()):
            queue_free()

            if body.has_method("on_hit"):
                body.on_hit(owner)
extends Area2D

const BULLET_SPEED = 150.0

var direction = Vector2(0, -1)
var speed_mod = 1.0
var owner = null

func _ready():
    set_process(true)

func _process(delta):
    move(direction * BULLET_SPEED * speed_mod * delta)

func set_bulletspeed_modifier(modifier):
    speed_mod = modifier

func set_owner(owner):
    self.owner = owner

func is_owner(obj):
    if owner == null:
        return false
    return owner.get_instance_ID() == obj.get_instance_ID()

func move(vec):
    set_pos(get_pos() + vec)

func set_direction(dir):
    direction = dir.normalized()
    look_at(get_global_pos() - (direction * 2))

func _on_bullet_body_enter(body):
    if body.is_in_group("hitable"):
        if owner == null or (owner != null and owner.get_instance_ID() != body.get_instance_ID()):
            if body.has_method("on_hit"):
                body.on_hit(owner)
            queue_free()

func _on_DestroyTimer_timeout():
    queue_free()
extends Sprite

var direction = Vector2(0, 1)

var owner = null

func _ready():
    set_process(true)

func set_owner(owner):
    self.owner = owner

func _process(delta):
    if owner != null:
        look_at(owner.get_pos() + direction)

func set_direction(dir):
    direction = dir

func direction():
    return direction

func turn(rad):
    var sinus = sin(rad)
    var cosinus = cos(rad)

    var tx = direction.x
    var ty = direction.y

    direction.x = (cosinus * tx) - (sinus * ty)
    direction.y = (sinus * tx) + (cosinus * ty)
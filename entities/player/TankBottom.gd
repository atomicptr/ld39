extends Sprite

var direction = Vector2(0, 1)

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

func direction():
    return direction

func update_direction(pos):
    look_at(pos + direction)

func turn(rad):
    var sinus = sin(rad)
    var cosinus = cos(rad)

    var tx = direction.x
    var ty = direction.y

    direction.x = (cosinus * tx) - (sinus * ty)
    direction.y = (sinus * tx) + (cosinus * ty)
extends Sprite

onready var CannonPosition = get_node("Cannon")

onready var Game = get_tree().get_root().get_node("Game")
onready var BulletContainer = Game.get_node("Container/Bullets")

onready var BulletScene = preload("res://entities/bullet/Bullet.tscn")

var owner = null

func set_owner(owner):
    self.owner = owner

func fire_bullet():
    var bullet = BulletScene.instance()
    bullet.set_owner(owner)

    var cannon_pos = CannonPosition.get_global_pos()

    var cannon_direction = -(get_global_pos() - cannon_pos).normalized()

    bullet.set_global_pos(cannon_pos)
    bullet.set_direction(cannon_direction)

    BulletContainer.add_child(bullet)
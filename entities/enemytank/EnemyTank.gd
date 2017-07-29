extends KinematicBody2D

onready var TopSprite = get_node("TopSprite")
onready var BottomSprite = get_node("BottomSprite")
onready var CannonPosition = TopSprite.get_node("Cannon")

onready var Game = get_tree().get_root().get_node("Game")
onready var Player = Game.get_node("Player")
onready var BulletContainer = Game.get_node("BulletContainer")

onready var BulletScene = preload("res://entities/bullet/Bullet.tscn")

func _ready():
    set_process(true)

func _process(delta):
    TopSprite.look_at(Player.get_pos())

func on_hit(by):
    for bullet in BulletContainer.get_children():
        if bullet.is_owner(self):
            bullet.set_owner(null)

    queue_free()

func _on_ReloadTimer_timeout():
    fire_bullet()

func fire_bullet():
    var bullet = BulletScene.instance()
    bullet.set_owner(self)
    bullet.set_bulletspeed_modifier(0.5)

    var cannon_pos = CannonPosition.get_global_pos()

    var cannon_direction = -(get_global_pos() - cannon_pos).normalized()

    bullet.set_global_pos(cannon_pos)
    bullet.set_direction(cannon_direction)

    BulletContainer.add_child(bullet)
extends KinematicBody2D

onready var TankCannon = get_node("TankCannon")
onready var BottomSprite = get_node("BottomSprite")

onready var Game = get_tree().get_root().get_node("Game")
onready var Player = Game.get_node("Player")

onready var BulletContainer = Game.get_node("BulletContainer")

func _ready():
    TankCannon.set_owner(self)

    set_process(true)

func _process(delta):
    TankCannon.look_at(Player.get_pos())

func on_hit(by):
    BulletContainer.purge_owner(self)

    queue_free()

func _on_ReloadTimer_timeout():
    TankCannon.fire_bullet()
extends KinematicBody2D

onready var TankCannon = get_node("TankCannon")
onready var TankBottom = get_node("TankBottom")

onready var Game = get_tree().get_root().get_node("Game")
onready var Player = Game.get_node("Player")

onready var BulletContainer = Game.get_node("Container/Bullets")

var velocity = Vector2(0, 0)
var desired_velocity = Vector2(0, 0)
var steering = Vector2(0, 0)

func _ready():
    TankCannon.set_owner(self)
    TankBottom.set_owner(self)
    set_process(true)

func _process(delta):
    TankCannon.look_at(Player.get_pos() + Player.velocity())

    desired_velocity = (Player.get_pos() - get_pos()).normalized() * 30
    steering = desired_velocity - velocity

    velocity += steering

    TankBottom.set_direction(velocity.normalized())

    move(velocity * delta)
    velocity *= 0.9

func on_hit(by):
    BulletContainer.purge_owner(self)

    if by != null and not by.is_in_group("enemy"):
        queue_free()

func _on_ReloadTimer_timeout():
    TankCannon.fire_bullet()
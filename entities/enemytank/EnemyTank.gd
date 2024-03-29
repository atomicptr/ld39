extends KinematicBody2D

onready var TankCannon = get_node("TankCannon")
onready var TankBottom = get_node("TankBottom")

onready var Game = get_tree().get_root().get_node("Game")
onready var Player = Game.get_node("Player")

onready var Nav = Game.get_node("Map/Navigation")

onready var BulletContainer = Game.get_node("Container/Bullets")

var velocity = Vector2(0, 0)
var desired_velocity = Vector2(0, 0)
var steering = Vector2(0, 0)

var points = []

func _ready():
    TankCannon.set_owner(self)
    TankBottom.set_owner(self)
    set_process(true)

func _process(delta):
    TankCannon.look_at(Player.get_pos() + Player.velocity())

    points = Nav.get_simple_path(get_pos(), Player.get_pos(), true)

    if points.size() > 1:
        desired_velocity = (points[1] - get_pos()).normalized() * 25
        steering = desired_velocity - velocity

        velocity += steering

    TankBottom.set_direction(velocity.normalized())

    move(velocity * delta)
    velocity *= 0.9

func on_hit(by):
    if by != null and not by.is_in_group("enemy"):
        Player.reward(10, 1)
        destroy()

func _on_ReloadTimer_timeout():
    if (get_pos() - Player.get_pos()).length() <= 200:
        TankCannon.fire_bullet()


func destroy():
    Game.explode(get_global_pos(), false)
    Game.sfx("explosion_big")
    BulletContainer.purge_owner(self)
    queue_free()
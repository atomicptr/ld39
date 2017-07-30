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

    update()

func on_hit(by):
    BulletContainer.purge_owner(self)

    if by != null and not by.is_in_group("enemy"):
        queue_free()

func _on_ReloadTimer_timeout():
    TankCannon.fire_bullet()

func _draw():
    if points.size() > 1:
        for p in points:
            draw_circle(p - get_global_pos(), 2, Color(1, 0, 0)) #
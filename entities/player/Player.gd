extends KinematicBody2D

onready var TopSprite = get_node("TopSprite")
onready var BottomSprite = get_node("BottomSprite")
onready var CannonPosition = TopSprite.get_node("Cannon")

onready var EnergyMeter = get_node("EnergyMeter")

onready var Game = get_tree().get_root().get_node("Game")
onready var BulletContainer = Game.get_node("BulletContainer")

onready var BulletScene = preload("res://entities/bullet/Bullet.tscn")

const ACCELERATION = 6.0
const TURN_RATE = 0.05

const BULLET_DELAY = 0.5

const ENERGY_MAX = 100
const ENERGY_BULLET_COST = 5

var velocity = Vector2(0, 0)
var direction = Vector2(0, 1)

var energy = 100

var time = 0.0
var last_bullet_shot = 0.0

func _ready():
    set_process(true)

func _process(delta):
    if Input.is_action_pressed("forward"):
        velocity += (direction * ACCELERATION * (1 + energy/200))

    if Input.is_action_pressed("backward"):
        velocity -= (direction * ACCELERATION * (1 + energy/200)) * 0.5

    if Input.is_action_pressed("turn_left"):
        turn(-TURN_RATE)

    if Input.is_action_pressed("turn_right"):
        turn(TURN_RATE)

    if Input.is_action_pressed("fire"):
        fire_bullet()

    # top looks at mouse
    TopSprite.look_at(get_global_mouse_pos())

    # bottom looks into direction
    BottomSprite.look_at(get_pos() + direction)

    move(velocity * delta)
    velocity *= 0.9

    time += delta

    # update energy meter ui
    EnergyMeter.set_val(energy)

func turn(rad):
    var sinus = sin(rad)
    var cosinus = cos(rad)

    var tx = direction.x
    var ty = direction.y

    direction.x = (cosinus * tx) - (sinus * ty)
    direction.y = (sinus * tx) + (cosinus * ty)

func fire_bullet():
    if time - last_bullet_shot >= (BULLET_DELAY * (1 - energy/200)) and reduce_energy(ENERGY_BULLET_COST):
        var bullet = BulletScene.instance()
        bullet.set_owner(self)

        var cannon_pos = CannonPosition.get_global_pos()

        var cannon_direction = -(get_global_pos() - cannon_pos).normalized()

        bullet.set_global_pos(cannon_pos)
        bullet.set_direction(cannon_direction)

        BulletContainer.add_child(bullet)

        last_bullet_shot = time

func reduce_energy(amount):
    if energy - amount >= 0:
        energy -= amount
        return true
    return false

func increase_energy(amount):
    energy = min(energy + amount, ENERGY_MAX)

func _on_EnergyTimer_timeout():
    increase_energy(1)

extends KinematicBody2D

onready var TankCannon = get_node("TankCannon")
onready var TankBottom = get_node("TankBottom")

onready var EnergyMeter = get_node("EnergyMeter")

onready var Game = get_tree().get_root().get_node("Game")

const ACCELERATION = 6.0
const TURN_RATE = 0.05

const BULLET_DELAY = 0.5

const ENERGY_MAX = 100
const ENERGY_BULLET_COST = 5

var velocity = Vector2(0, 0)

var energy = 100

var time = 0.0
var last_bullet_shot = 0.0

func _ready():
    TankBottom.set_owner(self)
    TankCannon.set_owner(self)

    set_process(true)

func _process(delta):
    if Input.is_action_pressed("forward"):
        velocity += (TankBottom.direction() * ACCELERATION * (1 + energy/200))

    if Input.is_action_pressed("backward"):
        velocity -= (TankBottom.direction() * ACCELERATION * (1 + energy/200)) * 0.5

    if Input.is_action_pressed("turn_left"):
        TankBottom.turn(-TURN_RATE)

    if Input.is_action_pressed("turn_right"):
        TankBottom.turn(TURN_RATE)

    if Input.is_action_pressed("fire"):
        fire_bullet()

    # top looks at mouse
    TankCannon.look_at(get_global_mouse_pos())

    move(velocity * delta)
    velocity *= 0.9

    time += delta

    # update energy meter ui
    EnergyMeter.set_val(energy)

func velocity():
    return velocity

func fire_bullet():
    if time - last_bullet_shot >= (BULLET_DELAY * (1 - energy/200)) and reduce_energy(ENERGY_BULLET_COST):
        velocity += TankCannon.direction() * ACCELERATION * (25 * (energy/100.0))
        print(ACCELERATION * (25 * (energy/100)), energy, energy/100.0)

        TankCannon.set_bulletspeed_modifier(1.0 + energy/200.0)
        TankCannon.fire_bullet()
        last_bullet_shot = time

func reduce_energy(amount):
    if energy - amount >= 0:
        energy -= amount
        return true
    return false

func increase_energy(amount):
    energy = min(energy + amount, ENERGY_MAX)

func reward(energy, money):
    increase_energy(energy)

func on_hit(by):
    if not reduce_energy(10):
        Game.end_game()
        hide()

func _on_EnergyTimer_timeout():
    increase_energy(10)

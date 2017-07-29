extends KinematicBody2D

onready var TopSprite = get_node("TopSprite")
onready var BottomSprite = get_node("BottomSprite")

onready var Game = get_tree().get_root().get_node("Game")
onready var Player = Game.get_node("Player")

func _ready():
    set_process(true)

func _process(delta):
    TopSprite.look_at(Player.get_pos())

func on_hit(by):
    queue_free()
extends Node2D

var wave_num = 0
var new_wave = true

onready var Enemies = get_node("Container/Enemies")

onready var SpawnPointTop = get_node("Container/Spawners/Top")
onready var SpawnPointBottom = get_node("Container/Spawners/Bottom")
onready var SpawnPointLeft = get_node("Container/Spawners/Left")
onready var SpawnPointRight = get_node("Container/Spawners/Right")

onready var EnemyTank = preload("res://entities/enemytank/EnemyTank.tscn")

onready var waves = [
    {
        "enemies": [
            {"type": EnemyTank, "location": SpawnPointTop, "number": 1},
            {"type": EnemyTank, "location": SpawnPointLeft, "number": 2},
            {"type": EnemyTank, "location": SpawnPointRight, "number": 2}
        ],
        "reward": 5
    }
]

onready var enemies_to_add = []

func _ready():
    set_process(true)

func _process(delta):
    var current_wave = waves[wave_num]

    if new_wave:
        for enemySpawn in current_wave["enemies"]:
            for i in range(0, enemySpawn.number):
                var enemy = enemySpawn["type"].instance()
                enemy.set_pos(enemySpawn["location"].get_pos())
                enemies_to_add.append(enemy)

        new_wave = false

func _on_SpawnTimer_timeout():
    if not enemies_to_add.empty():
        var enemy = enemies_to_add.front()
        enemies_to_add.pop_front()

        Enemies.add_child(enemy)
extends Node2D

var wave_num = 0
var new_wave = true
var waiting_for_pause_to_end = false

onready var Enemies = get_node("Container/Enemies")

onready var SpawnPointTop = get_node("Container/Spawners/Top")
onready var SpawnPointBottom = get_node("Container/Spawners/Bottom")
onready var SpawnPointLeft = get_node("Container/Spawners/Left")
onready var SpawnPointRight = get_node("Container/Spawners/Right")

onready var EnemyTank = preload("res://entities/enemytank/EnemyTank.tscn")

onready var Explosion = preload("res://entities/explosion/Explosion.tscn")
onready var ExplosionContainer = get_node("Container/Explosions")

onready var WaveLabel = get_node("UI/WaveLabel")
onready var EnemiesLeftLabel = get_node("UI/EnemiesLeftLabel")
onready var GameOverPanel = get_node("UI/GameOverPanel")
onready var GameOverLabel = get_node("UI/GameOverPanel/GameOverLabel")

onready var Sound = get_node("Container/Sound")

onready var WavePauseTimer = get_node("Container/Spawners/WavePauseTimer")

onready var waves = [
    {
        "enemies": [
            {"type": EnemyTank, "location": SpawnPointTop, "number": 1},
            {"type": EnemyTank, "location": SpawnPointLeft, "number": 1},
            {"type": EnemyTank, "location": SpawnPointRight, "number": 1}
        ],
        "reward": 5
    },
    {
        "enemies": [
            {"type": EnemyTank, "location": SpawnPointTop, "number": 1},
            {"type": EnemyTank, "location": SpawnPointLeft, "number": 1},
            {"type": EnemyTank, "location": SpawnPointRight, "number": 1},
            {"type": EnemyTank, "location": SpawnPointBottom, "number": 2},
            {"type": EnemyTank, "location": SpawnPointRight, "number": 1},
            {"type": EnemyTank, "location": SpawnPointLeft, "number": 1},
            {"type": EnemyTank, "location": SpawnPointTop, "number": 1}
        ],
        "reward": 8
    },
    {
        "enemies": [
            {"type": EnemyTank, "location": SpawnPointTop, "number": 2},
            {"type": EnemyTank, "location": SpawnPointLeft, "number": 2},
            {"type": EnemyTank, "location": SpawnPointRight, "number": 2},
            {"type": EnemyTank, "location": SpawnPointBottom, "number": 3},
            {"type": EnemyTank, "location": SpawnPointRight, "number": 2},
            {"type": EnemyTank, "location": SpawnPointLeft, "number": 2},
            {"type": EnemyTank, "location": SpawnPointTop, "number": 2}
        ],
        "reward": 12
    }
]

onready var enemies_to_add = []

func _ready():
    set_process(true)

func _process(delta):
    var current_wave = waves[wave_num]
    var enemies_left = Enemies.get_children().size() + enemies_to_add.size()

    WaveLabel.set_text(str("Wave: ", wave_num + 1))
    EnemiesLeftLabel.set_text(str("Enemies left: ", enemies_left))

    if new_wave:
        for enemySpawn in current_wave["enemies"]:
            for i in range(0, enemySpawn.number):
                var enemy = enemySpawn["type"].instance()
                enemy.set_pos(enemySpawn["location"].get_pos())
                enemies_to_add.append(enemy)
        new_wave = false
    elif enemies_left == 0 and not waiting_for_pause_to_end:
        if wave_num + 1 < waves.size():
            wave_num += 1
            waiting_for_pause_to_end = true
            WavePauseTimer.start()
        else:
            GameOverLabel.set_text("You Win!")
            end_game()

func end_game():
    get_tree().set_pause(true)
    GameOverPanel.show()

func explode(pos, sound=true):
    var explosion = Explosion.instance()
    ExplosionContainer.add_child(explosion)
    explosion.set_global_pos(pos)
    explosion.get_node("particles").set_emitting(true)
    if sound:
        sfx("explosion")
    return explosion

func _on_SpawnTimer_timeout():
    if not enemies_to_add.empty():
        var enemy = enemies_to_add.front()
        enemies_to_add.pop_front()

        Enemies.add_child(enemy)

func _on_WavePauseTimer_timeout():
    new_wave = true
    waiting_for_pause_to_end = false

func _on_RestartButton_pressed():
    get_tree().set_pause(false)
    get_tree().change_scene("res://Game.tscn")

func sfx(name):
    Sound.play(name)
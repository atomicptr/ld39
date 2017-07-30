extends Node2D

onready var ParticleSystem = get_node("particles")

func particles():
    return ParticleSystem

func _on_timer_timeout():
    queue_free() # free explosion
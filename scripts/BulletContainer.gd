extends Node2D

func purge_owner(owner):
    for bullet in get_children():
        if bullet.is_owner(owner):
            bullet.set_owner(null)